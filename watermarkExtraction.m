% watermarkExtraction.m
% Script untuk ekstraksi watermark dari gambar yang telah di-watermark

% Nama file gambar cover dan gambar yang telah di-watermark
coverImageFile = 'coverImage.jpeg'; % Ganti dengan path gambar cover Anda
watermarkedImageFile = 'watermarkedImage.jpg'; % Ganti dengan path gambar yang telah di-watermark

% Memeriksa keberadaan file gambar
if ~isfile(coverImageFile)
    error('File gambar cover tidak ditemukan: %s', coverImageFile);
end

if ~isfile(watermarkedImageFile)
    error('File gambar yang telah di-watermark tidak ditemukan: %s', watermarkedImageFile);
end

% Membaca gambar cover dan gambar yang telah di-watermark
coverImage = imread(coverImageFile);
watermarkedImage = imread(watermarkedImageFile);

% Mengubah tipe data ke double
coverImage = double(coverImage);
watermarkedImage = double(watermarkedImage);

% Menginisialisasi gambar watermark yang diekstraksi
extractedWatermark = zeros(size(coverImage), 'like', coverImage);

% Melakukan DWT dan ekstraksi pada setiap kanal warna
alpha = 0.05; % Faktor skala yang sama digunakan saat embedding
for k = 1:3
    % Mengambil kanal warna
    coverChannel = double(coverImage(:, :, k));
    watermarkedChannel = double(watermarkedImage(:, :, k));
    
    % Melakukan DWT pada kanal warna cover dan watermarked
    [LL_cover, ~, ~, ~] = dwt2(coverChannel, 'haar');
    [LL_watermarked, ~, ~, ~] = dwt2(watermarkedChannel, 'haar');
    
    % Mengubah ukuran sub-band agar sama jika diperlukan (misalnya jika terjadi perbedaan ukuran)
    [rowsLL, colsLL] = size(LL_cover);
    [rowsLL_watermarked, colsLL_watermarked] = size(LL_watermarked);
    
    if rowsLL ~= rowsLL_watermarked || colsLL ~= colsLL_watermarked
        LL_watermarked = imresize(LL_watermarked, [rowsLL, colsLL]);
    end
    
    % Ekstraksi watermark dari sub-band LL
    extractedWatermarkChannel = (LL_watermarked - LL_cover) / alpha;
    
    % Mengubah ukuran extractedWatermarkChannel agar sesuai dengan ukuran extractedWatermark
    extractedWatermarkChannel = imresize(extractedWatermarkChannel, size(extractedWatermark(:, :, k)));
    
    % Menambahkan hasil ekstraksi ke extractedWatermark
    extractedWatermark(:, :, k) = uint8(extractedWatermarkChannel);
end

% Menyimpan hasil ekstraksi watermark
imwrite(extractedWatermark, 'extractedWatermark.png');

% Menampilkan watermark asli dan hasil ekstraksi
figure;
subplot(1, 2, 1);
imshow(imread(watermarkImageFile));
title('Watermark Asli');

subplot(1, 2, 2);
imshow(extractedWatermark);
title('Watermark Hasil Ekstraksi');
