void main() {
  List<String> list = ['A', 'B', 'C'];

  // Thêm phần tử 'D' vào cuối List
  list.add('D');

  // Chèn phần tử 'X' vào vị trí thứ 1
  list.insert(1, 'X');

  // Xóa phần tử 'B'
  list.remove('B');

  // In ra độ dài của List
  print(list.length); // Output: 3
}
// Giải thích sự khác nhau giữa các phương thức:
// remove() và removeAt():
//remove(element) xóa phần tử đầu tiên có giá trị bằng element.
//removeAt(index) xóa phần tử tại vị trí index.
//add() và insert():
//add(element) thêm một phần tử vào cuối danh sách.
//insert(index, element) chèn một phần tử vào vị trí index.
//addAll() và insertAll():
//addAll(list) thêm tất cả các phần tử từ danh sách list vào cuối danh sách hiện tại.
//insertAll(index, list) chèn tất cả các phần tử từ danh sách list vào vị trí index.