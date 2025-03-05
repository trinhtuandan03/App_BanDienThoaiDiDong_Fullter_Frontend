import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:trinhtuandan_nhom3_2180602115/models/blog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BlogScreen extends StatefulWidget {
  const BlogScreen({super.key});

  @override
  _BlogScreenState createState() => _BlogScreenState();
}

class _BlogScreenState extends State<BlogScreen> {
  late Future<List<Blog>> blogs;
  String _selectedLanguage = 'Tiếng Việt';

  Future<void> _loadLanguage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _selectedLanguage = prefs.getString('language') ?? 'Tiếng Việt';
    });
  }

  Future<List<Blog>> fetchBlogs() async {
    const String apiUrl = 'https://earlymintbook2.conveyor.cloud/api/BlogsApi';
    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final List jsonResponse = json.decode(response.body);
        return jsonResponse.map((data) => Blog.fromJson(data)).toList();
      } else {
        throw Exception('Không thể tải bài viết. Vui lòng thử lại sau.');
      }
    } catch (e) {
      throw Exception('Lỗi kết nối: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    blogs = fetchBlogs();
    _loadLanguage();
  }

  @override
  Widget build(BuildContext context) {
    final isVietnamese = _selectedLanguage == 'Tiếng Việt';

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pinkAccent,
        elevation: 0,
        title: Text(
          isVietnamese ? 'Danh Sách Bài Viết' : 'Blog List',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
        ),
        centerTitle: true,
      ),
      body: FutureBuilder<List<Blog>>(
        future: blogs,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
                child: Text(isVietnamese
                    ? 'Lỗi: ${snapshot.error}'
                    : 'Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
                child: Text(isVietnamese
                    ? 'Không có bài viết nào.'
                    : 'No blogs available.'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final blog = snapshot.data![index];
                return BlogCard(
                    blog: blog, selectedLanguage: _selectedLanguage);
              },
            );
          }
        },
      ),
    );
  }
}

class BlogCard extends StatelessWidget {
  final Blog blog;
  final String selectedLanguage;

  const BlogCard(
      {super.key, required this.blog, required this.selectedLanguage});

  @override
  Widget build(BuildContext context) {
    final isVietnamese = selectedLanguage == 'Tiếng Việt';
    return Card(
      margin: const EdgeInsets.all(12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 4,
      shadowColor: Colors.pinkAccent,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (blog.imageUrl != null && blog.imageUrl!.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(12.0),
                child: Image.network(
                  blog.imageUrl!,
                  height: 180,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.broken_image, size: 180),
                ),
              )
            else
              const Icon(Icons.image_not_supported, size: 180),
            const SizedBox(height: 12),
            Text(
              blog.title ?? (isVietnamese ? 'Không có tiêu đề' : 'No Title'),
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              blog.content ??
                  (isVietnamese
                      ? 'Nội dung không khả dụng'
                      : 'Content not available'),
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black54,
                height: 1.5,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
            Text(
              '${isVietnamese ? 'Danh mục' : 'Category'}: ${blog.category ?? (isVietnamese ? 'Không xác định' : 'Uncategorized')}',
              style: const TextStyle(
                color: Colors.pinkAccent,
                fontStyle: FontStyle.italic,
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
