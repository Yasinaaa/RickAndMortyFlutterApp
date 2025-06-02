import 'package:flutter/material.dart';
import '../../domain/character.dart';

class CharacterCard extends StatefulWidget {
  final Character character;
  final bool isFavorite;
  final VoidCallback onFavoriteToggle;

  const CharacterCard({
    super.key,
    required this.character,
    required this.isFavorite,
    required this.onFavoriteToggle,
  });

  @override
  State<CharacterCard> createState() => _CharacterCardState();
}

class _CharacterCardState extends State<CharacterCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.3)
        .chain(CurveTween(curve: Curves.easeOutBack))
        .animate(_controller);
  }

  @override
  void didUpdateWidget(CharacterCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isFavorite != widget.isFavorite) {
      _controller.forward(from: 0.0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: ListTile(
        leading: Image.network(widget.character.image),
        title: Text(widget.character.name),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Status: ${widget.character.status}'),
            Text('Species: ${widget.character.species}'),
            Text('Location: ${widget.character.location}'),
          ],
        ),
        trailing: ScaleTransition(
          scale: _scaleAnimation,
          child: IconButton(
            icon: Icon(
              widget.isFavorite ? Icons.star : Icons.star_border,
              color: widget.isFavorite ? Colors.amber : null,
            ),
            onPressed: widget.onFavoriteToggle,
          ),
        ),
        isThreeLine: true,
      ),
    );
  }
}