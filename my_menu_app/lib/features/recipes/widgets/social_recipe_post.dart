import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../models/recipe_model.dart';
import 'package:provider/provider.dart';
import '../../shopping/providers/shopping_list_provider.dart';

class SocialRecipePost extends StatefulWidget {
  final Recipe recipe;
  final String username;
  final String userAvatarUrl;
  final int initialLikes;

  const SocialRecipePost({
    super.key,
    required this.recipe,
    required this.username,
    required this.userAvatarUrl,
    required this.initialLikes,
  });

  @override
  State<SocialRecipePost> createState() => _SocialRecipePostState();
}

class _SocialRecipePostState extends State<SocialRecipePost> {
  bool _isLiked = false;
  late int _likes;
  bool _showIngredients = false;

  @override
  void initState() {
    super.initState();
    _likes = widget.initialLikes;
  }

  void _toggleLike() {
    setState(() {
      _isLiked = !_isLiked;
      _likes += _isLiked ? 1 : -1;
    });
  }

  void _toggleIngredients() {
    setState(() {
      _showIngredients = !_showIngredients;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: User Info
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundImage: NetworkImage(widget.userAvatarUrl),
                ),
                const SizedBox(width: 12),
                Text(
                  widget.username,
                  style: GoogleFonts.outfit(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: const Color(0xFF1A313A),
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.more_horiz),
                  onPressed: () {},
                  color: Colors.grey,
                ),
              ],
            ),
          ),

          // Recipe Image
          Container(
            height: 300,
            width: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: widget.recipe.imageUrl.startsWith('http')
                    ? NetworkImage(widget.recipe.imageUrl)
                    : AssetImage(widget.recipe.imageUrl) as ImageProvider,
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Action Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            child: Row(
              children: [
                _ActionButton(
                  icon: _isLiked ? Icons.favorite : Icons.favorite_border,
                  color: _isLiked ? Colors.red : const Color(0xFF1A313A),
                  onTap: _toggleLike,
                ),
                const SizedBox(width: 16),
                _ActionButton(icon: Icons.chat_bubble_outline, onTap: () {}),
                const SizedBox(width: 16),
                _ActionButton(icon: Icons.share_outlined, onTap: () {}),
                const Spacer(),
                _ActionButton(
                  icon: _showIngredients ? Icons.folder_open : Icons.folder,
                  color: AppColors.primary,
                  onTap: _toggleIngredients,
                ),
              ],
            ),
          ),

          // Likes Count
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              '$_likes Me gusta',
              style: GoogleFonts.inter(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),

          // Description & Title
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: const Color(0xFF1A313A),
                    ),
                    children: [
                      TextSpan(
                        text: '${widget.username} ',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(
                        text: widget.recipe.title,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      const TextSpan(text: '\n'),
                      TextSpan(
                        text: widget.recipe.description,
                        style: TextStyle(color: Colors.grey[800]),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Ingredients Section (Expandable)
          AnimatedCrossFade(
            firstChild: const SizedBox(height: 0),
            secondChild: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              color: const Color(0xFFF9F9F5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Ingredientes',
                        style: GoogleFonts.outfit(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: AppColors.primary,
                        ),
                      ),
                      TextButton.icon(
                        onPressed: () {
                          context.read<ShoppingListProvider>().addItems(
                            widget.recipe.ingredients,
                          );
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                '${widget.recipe.title} añadida a tu lista!',
                              ),
                              backgroundColor: AppColors.primary,
                              behavior: SnackBarBehavior.floating,
                              duration: const Duration(seconds: 2),
                            ),
                          );
                        },
                        icon: const Icon(
                          Icons.playlist_add,
                          size: 18,
                          color: AppColors.primary,
                        ),
                        label: Text(
                          'Añadir',
                          style: GoogleFonts.inter(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                        ),
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ...widget.recipe.ingredients.map(
                    (ingredient) => Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.circle,
                            size: 6,
                            color: AppColors.primary,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              ingredient,
                              style: GoogleFonts.inter(fontSize: 13),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            crossFadeState: _showIngredients
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 300),
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final Color color;

  const _ActionButton({
    required this.icon,
    required this.onTap,
    this.color = const Color(0xFF1A313A),
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Icon(icon, size: 28, color: color),
    );
  }
}
