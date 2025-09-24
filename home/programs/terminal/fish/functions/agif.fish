function agif --argument url -d 'Download a YouTube video and save it as a gif for anki'

    yt-dlp -f bestvideo -t mp4 "$url" -o - | ffmpeg -i pipe: -an -filter:v "fps=30,scale=1920x1080:flags=bicublin" -f yuv4mpegpipe - | gifski -o output.gif --fps 30 --quality 85 --lossy-quality=30 -

    echo "Successfully downloaded $url"
end
