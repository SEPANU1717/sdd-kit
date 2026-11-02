# Encodes the rendered frames (59.94 fps PNGs) with the soundtrack into an MP4: H.264 4:2:0 at 60000/1001, AAC 256k
# 48 kHz, loudness -14 LUFS with true peak -1 dBTP, BT.709, faststart.
#   pwsh promo/encode.ps1 -Film 5 -Name product        out/v5/frames + out/audio-film.wav -> out/product-film-v5.mp4
# FFmpeg: -FFmpeg <path>, or ffmpeg on PATH.
param([string]$Film = "1", [string]$Name = "product", [string]$Audio = "", [string]$FFmpeg = "ffmpeg")
$out = Join-Path $PSScriptRoot "out"
$frames = Join-Path (Join-Path (Join-Path $out "v$Film") "frames") "%05d.png"
if (-not $Audio) { $Audio = Join-Path $out "audio-film.wav" }
$file = Join-Path $out "$Name-film-v$Film.mp4"
# Intel Quick Sync first; software x264 (or OpenH264) when it isn't available.
& $FFmpeg -hide_banner -loglevel error -y `
  -framerate 60000/1001 -i $frames -i $Audio -map 0:v -map 1:a `
  -c:v h264_qsv -preset veryslow -global_quality 18 -pix_fmt nv12 `
  -af "loudnorm=I=-14:TP=-1:LRA=11" -c:a aac -b:a 256k -ar 48000 `
  -shortest -movflags +faststart -color_primaries bt709 -color_trc bt709 -colorspace bt709 $file
if ($LASTEXITCODE -ne 0) {
  & $FFmpeg -hide_banner -loglevel error -y `
    -framerate 60000/1001 -i $frames -i $Audio -map 0:v -map 1:a `
    -c:v libx264 -preset slow -crf 16 -pix_fmt yuv420p -af "loudnorm=I=-14:TP=-1:LRA=11" -c:a aac -b:a 256k -ar 48000 `
    -shortest -movflags +faststart $file
}
if ($LASTEXITCODE -ne 0) {
  & $FFmpeg -hide_banner -loglevel error -y `
    -framerate 60000/1001 -i $frames -i $Audio -map 0:v -map 1:a `
    -c:v libopenh264 -b:v 16M -pix_fmt yuv420p -af "loudnorm=I=-14:TP=-1:LRA=11" -c:a aac -b:a 256k -ar 48000 `
    -shortest -movflags +faststart $file
}
Get-Item $file | Select-Object Name, @{n = "MB"; e = { [math]::Round($_.Length / 1MB, 1) } }
