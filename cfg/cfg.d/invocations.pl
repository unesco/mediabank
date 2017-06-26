# remove -vpre default, disambiguate -b, add -strict experimental
$c->{invocation}->{ffmpeg_i} = '$(ffmpeg) -i $(SOURCE)';
# remove -vpre default, disambiguate -b, add -strict experimental
$c->{invocation}->{ffmpeg_video_mp4} = '$(ffmpeg) -y -i $(SOURCE) -acodec $(audio_codec) -ac 2 -ar $(audio_sampling) -ab $(audio_bitrate) -f $(container) -codec:v $(video_codec) -r $(video_frame_rate) -b $(video_bitrate) -s $(width)x$(height) $(TARGET)';
# remove -vpre default, disambiguate -b, add -strict experimental
$c->{invocation}->{ffmpeg_video_ogg} = '$(ffmpeg) -y -i $(SOURCE) -acodec $(audio_codec) -ac 2 -ar $(audio_sampling) -ab $(audio_bitrate) -f $(container) -codec:v $(video_codec) -r $(video_frame_rate) -b $(video_bitrate) -s $(width)x$(height) $(TARGET)';
# remove -vpre default, disambiguate -b, add -strict experimental
$c->{invocation}->{ffmpeg_audio_mp4} = '$(ffmpeg) -y -i $(SOURCE) -acodec $(audio_codec) -ac 2 -ar $(audio_sampling) -ab $(audio_bitrate) -f $(container) $(TARGET)';
# remove -vpre default, disambiguate -b, add -strict experimental
$c->{invocation}->{ffmpeg_audio_ogg} = '$(ffmpeg) -y -i $(SOURCE) -acodec $(audio_codec) -ac 2 -ar $(audio_sampling) -ab $(audio_bitrate) -f $(container) $(TARGET)';
# remove -vpre default, disambiguate -b, add -strict experimental
$c->{invocation}->{ffmpeg_cell} = '$(ffmpeg) -y -i $(SOURCE) -an -f mjpeg -ss $(offset) -t 00:00:01 -r 1 -s $(width)x$(height) $(TARGET)';
