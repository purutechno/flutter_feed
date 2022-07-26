import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_feed/pages/splashscreen/widget/loader.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

const _mutedVolume = 0.0;
const _unMutedVolume = 1.0;
const _iconBackgroundOpacity = 0.7;
const _halfVisible = 0.5;

class FeedVideoPlayer extends StatefulWidget {
  factory FeedVideoPlayer.local({
    required String path,
    bool showScrubber = true,
  }) =>
      FeedVideoPlayer._(
        path: path,
        showScrubber: showScrubber,
      );

  factory FeedVideoPlayer.network({
    required String url,
    bool showScrubber = true,
    bool autoPlay = false,
  }) =>
      FeedVideoPlayer._(
        url: url,
        showScrubber: showScrubber,
        autoPlay: autoPlay,
      );

  const FeedVideoPlayer._({
    this.path,
    this.url,
    this.showScrubber = true,
    this.autoPlay = false,
    Key? key,
  }) : super(key: key);

  final String? path;
  final String? url;

  /// showScrubber which basically changes the following properties:
  ///    a) true
  ///       i) displays play/pause button alongside VideoProgressIndicator,
  ///       ii) displays VideoProgressIndicator that allows us to change the position by dragging it to a position,
  ///       iii) displays the current position via timing - (Currently Supports 60 seconds as Max display time)
  ///       iv) toggles mute when tapped on video screen,
  ///
  ///
  ///    b) false
  ///       i) displays play/pause button with fixed size in the center,
  ///       ii) hides VideoProgressIndicator,
  ///       iii) hides the current position via timing,
  ///       iv) toggles play when tapped on video
  ///       v) displays playPause toggle on the screen
  final bool showScrubber;

  /// Allows the video to play itself,
  /// The timer will be displayed at top right of the screen,
  /// Allows to toggle play when tapped on screen
  final bool autoPlay;

  @override
  State<FeedVideoPlayer> createState() => _FeedVideoPlayerState();
}

class _FeedVideoPlayerState extends State<FeedVideoPlayer> {
  late final VideoPlayerController _videoPlayerController;
  final ValueNotifier<bool> _isMutedNotifier = ValueNotifier<bool>(false);

  ///excused immutability, used for state
  bool _playerInitialized = false;

  @override
  void initState() {
    if (widget.autoPlay) _isMutedNotifier.value = false;
    _initializeVideoController();
    super.initState();
  }

  Key get _getKey => widget.url != null ? Key(widget.url!) : Key(widget.path!);

  @override
  Widget build(BuildContext context) => _playerInitialized
      ? Column(
          children: [
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                VisibilityDetector(
                  key: _getKey,
                  onVisibilityChanged: _onVisibilityChanged,
                  child: _Video(
                    showScrubber: widget.showScrubber,
                    videoPlayerController: _videoPlayerController,
                    isMutedNotifier: _isMutedNotifier,
                  ),
                ),
                if (widget.autoPlay)
                  Positioned.fill(
                    top: 16.0,
                    right: 24.0,
                    child: Align(
                      alignment: Alignment.topRight,
                      child: _CurrentVideoPosition(
                        videoPlayerController: _videoPlayerController,
                      ),
                    ),
                  ),
                if (!widget.showScrubber && !widget.autoPlay)
                  Positioned.fill(
                    child: _TogglePlayButton.centered(videoPlayerController: _videoPlayerController),
                  ),
                Padding(
                  padding: EdgeInsets.only(right: 24.0, bottom: _getBottomPadding),
                  child: _ToggleMuteButton(
                    isMuted: _isMutedNotifier,
                    toggleMuteUnMute: () => _toggleMute(
                      _videoPlayerController,
                      _isMutedNotifier,
                    ),
                  ),
                ),
              ],
            ),
            if (widget.showScrubber) _VideoControls(videoPlayerController: _videoPlayerController),
          ],
        )
      : const Loader();

  void _onVisibilityChanged(VisibilityInfo info) {
    if (info.visibleFraction > _halfVisible && _videoPlayerController.value.isInitialized) {
      if (widget.autoPlay) {
        _videoPlayerController.setVolume(_unMutedVolume);
        _videoPlayerController.setLooping(true);
        _videoPlayerController.play();
      }
    } else if (info.visibleFraction <= 0 && _videoPlayerController.value.isInitialized) {
      _videoPlayerController.pause();
    }
  }

  double get _getBottomPadding => widget.autoPlay ? 24.0 : 32.0;

  void _initializeVideoController() {
    if (widget.url != null) {
      _videoPlayerController = VideoPlayerController.network(widget.url!);
    } else if (widget.path != null) {
      _videoPlayerController = VideoPlayerController.file(File(widget.path!));
    } else {
      throw Exception('Either URl or Path must not be null');
    }

    _videoPlayerController.initialize();

    _videoPlayerController.addListener(() {
      if (_videoPlayerController.value.isInitialized) {
        if (mounted) setState(() => _playerInitialized = true);
      } else if (_videoPlayerController.value.hasError) {
        //todo: Catch Error For Video Player
      }
    });
  }

  @override
  void dispose() {
    _videoPlayerController.removeListener(() => _videoPlayerController.dispose());
    _isMutedNotifier.dispose();
    super.dispose();
  }
}

void _toggleMute(VideoPlayerController videoPlayerController, ValueNotifier<bool> isMutedNotifier) {
  if (videoPlayerController.value.volume == _mutedVolume) {
    isMutedNotifier.value = false;
    videoPlayerController.setVolume(_unMutedVolume);
  } else {
    isMutedNotifier.value = true;
    videoPlayerController.setVolume(_mutedVolume);
  }
}

void _togglePlay(VideoPlayerController videoPlayerController) =>
    videoPlayerController.value.isPlaying ? videoPlayerController.pause() : videoPlayerController.play();

class _Video extends StatelessWidget {
  const _Video({
    required this.videoPlayerController,
    required this.showScrubber,
    required this.isMutedNotifier,
    Key? key,
  }) : super(key: key);
  final bool showScrubber;
  final VideoPlayerController videoPlayerController;
  final ValueNotifier<bool> isMutedNotifier;

  bool get _isVideoPortrait => videoPlayerController.value.aspectRatio < 1.0;

  @override
  Widget build(BuildContext context) => SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: GestureDetector(
          onTap: () =>
              showScrubber ? _toggleMute(videoPlayerController, isMutedNotifier) : _togglePlay(videoPlayerController),
          child: FittedBox(
            /// (_isVideoPortrait && widget.showScrubber) == false, The video should fill up the entire space
            fit: _isVideoPortrait && showScrubber ? BoxFit.fitHeight : BoxFit.cover,
            child: SizedBox(
              width: videoPlayerController.value.size.width,
              height: videoPlayerController.value.size.height,
              child: VideoPlayer(videoPlayerController),
            ),
          ),
        ),
      );
}

class _VideoControls extends StatelessWidget {
  const _VideoControls({
    Key? key,
    required this.videoPlayerController,
  }) : super(key: key);
  final VideoPlayerController videoPlayerController;

  @override
  Widget build(BuildContext context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(
            height: 28.0,
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _TogglePlayButton(
                  videoPlayerController: videoPlayerController,
                ),
                const SizedBox(
                  width: 8.0,
                ),
                Expanded(
                  child: VideoProgressIndicator(
                    videoPlayerController,
                    allowScrubbing: true,
                    colors: const VideoProgressColors(
                      backgroundColor: Colors.white,
                      playedColor: Colors.green,
                    ),
                    padding: EdgeInsets.zero,
                  ),
                ),
                const SizedBox(
                  width: 16.0,
                ),
                _CurrentVideoPosition(videoPlayerController: videoPlayerController),
              ],
            ),
          ),
        ],
      );
}

const _centeredPlayPauseSize = 56.0;
const _playPauseParentSize = 108.0;

class _TogglePlayButton extends StatefulWidget {
  const _TogglePlayButton.centered({required this.videoPlayerController, Key? key})
      : centeredIcon = true,
        super(key: key);

  const _TogglePlayButton({required this.videoPlayerController, Key? key})
      : centeredIcon = false,
        super(key: key);

  final VideoPlayerController videoPlayerController;
  final bool centeredIcon;

  @override
  _TogglePlayButtonState createState() => _TogglePlayButtonState();
}

class _TogglePlayButtonState extends State<_TogglePlayButton> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 450));
    widget.videoPlayerController.addListener(() {
      if (widget.videoPlayerController.value.position == widget.videoPlayerController.value.duration) {
        _animationController.reverse();
      } else if (widget.videoPlayerController.value.isPlaying) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) => Align(
        alignment: Alignment.center,
        child: Container(
          height: widget.centeredIcon ? _playPauseParentSize : null,
          width: widget.centeredIcon ? _playPauseParentSize : null,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: widget.centeredIcon ? Colors.black.withOpacity(_iconBackgroundOpacity) : Colors.transparent,
          ),
          child: IconButton(
            alignment: Alignment.center,
            padding: EdgeInsets.zero,
            onPressed: () => _togglePlayPauseAndChangeIcon,
            icon: AnimatedIcon(
              icon: AnimatedIcons.play_pause,
              size: widget.centeredIcon ? _centeredPlayPauseSize : null,
              color: Colors.white,
              progress: _animationController,
            ),
          ),
        ),
      );

  void get _togglePlayPauseAndChangeIcon => widget.videoPlayerController.value.isPlaying
      ? widget.videoPlayerController.pause()
      : widget.videoPlayerController.play();

  @override
  void dispose() {
    /// Stops running the animation if any is in progress
    _animationController.stop();
    widget.videoPlayerController.removeListener(() => _animationController.dispose());
    super.dispose();
  }
}

class _ToggleMuteButton extends StatelessWidget {
  const _ToggleMuteButton({
    Key? key,
    required this.isMuted,
    required this.toggleMuteUnMute,
  }) : super(key: key);
  final ValueNotifier<bool> isMuted;
  final VoidCallback toggleMuteUnMute;

  @override
  Widget build(BuildContext context) => CircleAvatar(
        backgroundColor: Colors.black.withOpacity(_iconBackgroundOpacity),
        child: ValueListenableBuilder<bool>(
          valueListenable: isMuted,
          builder: (cxt, isMuted, child) => IconButton(
            onPressed: toggleMuteUnMute,
            icon: Icon(isMuted ? Icons.volume_off_rounded : Icons.volume_up),
          ),
        ),
      );
}

const _currentVideoPositionWidth = 38.0;
const _minTwoDigitValue = 10;

class _CurrentVideoPosition extends StatefulWidget {
  const _CurrentVideoPosition({
    Key? key,
    required this.videoPlayerController,
  }) : super(key: key);
  final VideoPlayerController videoPlayerController;

  @override
  _CurrentVideoPositionState createState() => _CurrentVideoPositionState();
}

class _CurrentVideoPositionState extends State<_CurrentVideoPosition> {
  int _currentDurationInSecond = 0;

  @override
  void initState() {
    widget.videoPlayerController.addListener(
      () {
        if (mounted) {
          setState(() => _currentDurationInSecond = widget.videoPlayerController.value.position.inSeconds);
        }
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) => _currentDurationInSecond <= 0
      ? const SizedBox.shrink()
      : SizedBox(
          width: _currentVideoPositionWidth,
          child: Text(
            _formatCurrentPosition(),
            style: Theme.of(context).textTheme.bodyText1?.copyWith(
                  color: Colors.white,
                ),
            maxLines: 1,
          ),
        );

  String _formatCurrentPosition() =>
      _currentDurationInSecond < _minTwoDigitValue ? "0 : 0$_currentDurationInSecond" : "0 : $_currentDurationInSecond";
}
