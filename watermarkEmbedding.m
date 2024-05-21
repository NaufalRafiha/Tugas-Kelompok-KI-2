% watermarkEmbedding.m
% Script untuk embedding watermark menggunakan DWT

% Nama file gambar cover dan watermark
coverImageFile = 'coverImage.jpeg'; % Ganti dengan path gambar cover Anda
watermarkImageFile = 'watermarkImage.png'; % Ganti dengan path gambar watermark Anda

% Memeriksa keberadaan file gambar
if ~isfile(coverImageFile)
    error('File gambar cover tidak ditemukan: %s', coverImageFile);
end

if ~isfile(watermarkImageFile)
    error('File gambar watermark tidak ditemukan: %s', watermarkImageFile);
end

% Membaca gambar cover dan gambar watermark
coverImage = imread(coverImageFile);
watermarkImage = imread(watermarkImageFile);

% Mengubah gambar watermark ke grayscale jika berwarna
if size(watermarkImage, 3) == 3
    watermarkImage = rgb2gray(watermarkImage);
end

% Mengubah tipe data ke double
watermarkImage = double(watermarkImage);

% Menginisialisasi gambar hasil watermarking
watermarkedImage = zeros(size(coverImage), 'like', coverImage);

% Melakukan DWT dan embedding pada setiap kanal warna
alpha = 0.05; % Faktor skala untuk watermark
for k = 1:3
    % Mengambil kanal warna
    coverChannel = double(coverImage(:, :, k));
    
    % Melakukan DWT pada kanal warna cover
    [LL, LH, HL, HH] = dwt2(coverChannel, 'haar');
    
    % Mengubah ukuran gambar watermark agar sesuai dengan ukuran sub-band LL
    [rowsLL, colsLL] = size(LL);
    watermarkImageResized = imresize(watermarkImage, [rowsLL, colsLL]);
    
    % Melakukan embedding watermark pada sub-band LL
    LL_watermarked = LL + alpha * watermarkImageResized;
    
    % Menggabungkan kembali sub-band
    watermarkedChannel = idwt2(LL_watermarked, LH, HL, HH, 'haar');
    
    % Menyimpan kanal warna hasil watermarking
    watermarkedImage(:, :, k) = uint8(watermarkedChannel);
end

% Menyimpan gambar hasil watermarking
imwrite(watermarkedImage, 'watermarkedImage.jpg');

% Menampilkan gambar asli dan gambar hasil watermarking
figure;
subplot(1, 2, 1);
imshow(coverImage);
title('Gambar Asli');

subplot(1, 2, 2);
imshow(watermarkedImage);
title('Gambar dengan Watermark');
