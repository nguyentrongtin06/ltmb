void main() {
  // Tạo một Runes chứa ký tự emoji cười
  Runes runes = Runes('\u{1F600}');
  
  // Chuyển đổi Runes thành String
  String emoji = String.fromCharCodes(runes);
  
  // In ra số lượng điểm mã của Runes
  print(runes.length); // Output: 1
  
  // In ra emoji
  print(emoji); // Output: 😀
}