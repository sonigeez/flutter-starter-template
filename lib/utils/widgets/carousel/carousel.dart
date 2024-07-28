import 'package:flutter/material.dart';

class Carousel extends StatefulWidget {
  final List<String> imgList;

  const Carousel({super.key, required this.imgList});

  @override
  State<Carousel> createState() => _CarouselState();
}

class _CarouselState extends State<Carousel> {
  final PageController _controller = PageController();
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      int next = _controller.page!.round();
      if (_currentPage != next) {
        setState(() {
          _currentPage = next;
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: PageView.builder(
            controller: _controller,
            itemCount: widget.imgList.length,
            itemBuilder: (context, index) {
              return Image.network(
                widget.imgList[index],
                fit: BoxFit.cover,
              );
            },
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            widget.imgList.length,
            (index) => _buildIndicator(index == _currentPage),
          ),
        ),
      ],
    );
  }

  Widget _buildIndicator(bool isActive) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 5.0),
      height: 10.0,
      width: isActive ? 12.0 : 8.0,
      decoration: BoxDecoration(
        color: isActive ? Colors.blue : Colors.grey,
        borderRadius: const BorderRadius.all(Radius.circular(5)),
      ),
    );
  }
}
