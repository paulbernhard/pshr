# use streamio-ffmpeg
require 'streamio-ffmpeg'

module Pshr::Processors::Video

  def self.process(file, mime_type = nil)
    # compress video, trim teaser and extract still
    video = Tempfile.new(['video', '.mp4'], binmode: true)
    teaser = Tempfile.new(['teaser', '.mp4'], binmode: true)
    still = Tempfile.new(['still', '.jpg'], binmode: true)

    movie = FFMPEG::Movie.new(file.path)

    # transcode videos to tempfiles
    movie.transcode(video.path, video_encoding_settings)
    movie.transcode(teaser.path, teaser_encoding_settings)

    # extract still to tempfile
    movie.screenshot(still.path)

    { video: video, teaser: teaser, still: still }
  end

  private

    def video_encoding_settings
      %w(-c:v libx264 -preset slow -profile:v baseline -crf 26 -movflags faststart -c:a aac -b:a 320k -f mp4 -strict -2)
    end

    def teaser_encoding_settings
      %w(-ss 0 -t 4 -c:v libx264 -preset slow -profile:v baseline -crf 26 -movflags faststart -vf scale=480:-2 -an -f mp4 -strict -2)
    end
end
