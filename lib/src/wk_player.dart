part of '../wk_gift_player.dart';

class _WKPlayer {
  void Function(Map<dynamic, dynamic>?)? _finishedCallBack;
  Completer<Map<dynamic, dynamic>?>? _currentCompleter;
  Timer? _timeoutTimer;

  static final instance = _WKPlayer._();

  _WKPlayer._() {}

  BuildContext? _currentContext;
  OverlayEntry? _currentOverlay;

  void _addGiftOverlay() {
    if (_currentContext == null) return;

    _removeGiftOverlay();

    try {
      _currentOverlay = OverlayEntry(
        builder:
            (context) => IgnorePointer(
              child: Material(
                color: Colors.transparent,
                child: Stack(children: [Positioned.fill(child: VapView())]),
              ),
            ),
      );

      final overlay = Overlay.of(_currentContext!, rootOverlay: true);
      if (_currentOverlay != null) {
        overlay.insert(_currentOverlay!);
      }
    } catch (e) {
      debugPrint('添加 Overlay 失败: $e');
    }
  }

  void _removeGiftOverlay() {
    try {
      if (_currentOverlay != null && _currentOverlay!.mounted) {
        _currentOverlay?.remove();
      }
    } catch (e) {
      debugPrint('移除 Overlay 失败: $e');
    } finally {
      _currentOverlay = null;
    }
  }

  void playGiftKey({
    required BuildContext context,
    required String key,
    Function(Map<dynamic, dynamic>?)? callback,
  }) async {
    _currentContext = context;
    _finishedCallBack = callback;
    FocusManager.instance.primaryFocus?.unfocus();

    try {
      // 确保停止之前的播放
      VapController.stop();
      final videoPath = await _WKVideoLoader.instance.loadVideo(key: key);

      debugPrint('播放礼物动画 step1 videoPath:$videoPath');

      // 添加 overlay 要在播放之前
      _addGiftOverlay();
      await Future.delayed(const Duration(milliseconds: 100));

      await _playVideoPath(videoPath);
    } catch (err) {
      debugPrint('播放礼物动画 $key error: $err');
    } finally {
      _removeGiftOverlay();
    }
  }

  Future<Map<dynamic, dynamic>?> _playVideoPath(String? path) async {
    debugPrint('播放礼物动画 step2 _playVideoPath $path');
    if (path == null || path.isEmpty) {
      _removeGiftOverlay();
      return null;
    }

    try {
      // 取消之前的播放任务
      _timeoutTimer?.cancel();
      _currentCompleter?.complete(null);

      debugPrint('播放礼物动画 step3.9 开始播放: $path');

      _currentCompleter = Completer<Map<dynamic, dynamic>?>();

      // 设置新的超时
      _timeoutTimer = Timer(const Duration(seconds: 30), () {
        if (_currentCompleter?.isCompleted == false) {
          debugPrint('播放礼物动画超时');
          _currentCompleter?.complete(null);
        }
      });

      // 播放动画
      VapController.playPath(path)
          .then((res) {
            debugPrint('播放礼物动画成功完成: $res');
            if (_currentCompleter?.isCompleted == false) {
              _currentCompleter?.complete(res);
            }
          })
          .catchError((error) {
            debugPrint('VapController.playPath 错误: $error');
            if (_currentCompleter?.isCompleted == false) {
              _currentCompleter?.complete(null);
            }
          });

      final res = await _currentCompleter!.future;

      // 添加短暂延迟，确保动画完全播放完
      await Future.delayed(const Duration(milliseconds: 200));

      debugPrint('播放礼物动画 step4 播放结果: $res');

      if (_finishedCallBack != null) {
        _finishedCallBack!(res);
      }
      return res;
    } catch (err, stack) {
      debugPrint('播放礼物动画错误: $err\n$stack');
      return null;
    } finally {
      _timeoutTimer?.cancel();
      _timeoutTimer = null;
      _currentCompleter = null;
    }
  }
}
