import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:tsuki/core/theme/app_colors.dart';
import 'particle_explosion.dart';

class HistoryTile extends StatefulWidget {
  final String title;
  final String artist;
  final String thumbnail;
  final String duration;
  final String id;
  final VoidCallback onPress;

  const HistoryTile({
    super.key,
    required this.title,
    required this.artist,
    required this.thumbnail,
    required this.duration,
    required this.id,
    required this.onPress,
  });

  @override
  State<HistoryTile> createState() => _HistoryTileState();
}

class _HistoryTileState extends State<HistoryTile> {
  bool _exploding = false;

  @override
  Widget build(BuildContext context) {
    return ParticleExplosion(
      trigger: _exploding,
      onComplete: () {
        if (!_exploding) return;
        _exploding = false;
        widget.onPress();
      },
      child: _buildTile(),
    );
  }

  Widget _buildTile() {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.terminalAmber),
      ),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.terminalAmber),
              ),
              child: CachedNetworkImage(
                imageUrl: widget.thumbnail,
                width: 64,
                height: 64,
                fit: BoxFit.cover,
                filterQuality: FilterQuality.high,
                placeholder: (context, url) =>
                    Container(color: AppColors.terminalAmber.withOpacity(0.1)),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: AppColors.terminalAmber,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  widget.artist,
                  style: TextStyle(
                    color: AppColors.terminalAmber,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  widget.duration,
                  style: TextStyle(color: AppColors.terminalAmber),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: IconButton(
              onPressed: () => setState(() => _exploding = true),
              icon: Icon(Icons.cancel_rounded),
              color: AppColors.terminalAmber,
            ),
          ),
        ],
      ),
    );
  }
}
