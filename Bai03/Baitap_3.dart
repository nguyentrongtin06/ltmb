void main() {
  Map<String, dynamic> user = {
    'name': 'Nam',
    'age': 20,
    'isStudent': true
  };

  // Thêm email
  user['email'] = 'nam@gmail.com';
  
  // Cập nhật age
  user['age'] = 21;
  
  // Xóa trường isStudent
  user.remove('isStudent');
  
  // Kiểm tra xem Map có chứa key 'phone' không
  bool containsPhone = user.containsKey('phone');
  print(containsPhone); // Output: false
}
//So sánh hai cách truy cập giá trị trong Map:
//user['phone']: Trả về null nếu key không tồn tại.
//user['phone'] ?? 'Không có số điện thoại': Trả về 'Không có số điện thoại' nếu key không tồn tại.
//Viết hàm in ra tất cả các cặp key-value:
void printMap(Map<String, dynamic> map) {
  map.forEach((key, value) {
    print('$key: $value');
  });
}