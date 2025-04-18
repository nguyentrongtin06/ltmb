void main()
{
  List<String> list1 = ['A', 'B','C'];
  var list2 = [1,2,3];
  List<String  > list3 = [];
  var list4 = List<int>.filled(3,0);
  print (list4);
  //1 Them Phan Tu
  list1.add ('D');        //them 1 phan tu
  list1.addAll(['A','C']);    //Them nhieu phan tu
  list1.insert(0,'Z');      //Chen 1 phan tu
  list1.insertAll(1,['1','0']);     //Chen nhieu phan tu
  print (list1);
  // 2 Xoa phan tu ben trong list
  list1.remove('A');    //Xoa phan tu tai vi tri A
  print(list1);       //Xoa phan tu tai vi tri 0
  list1.removeLast;       //Xoa phan tu cuooi cung
  list1.removeWhere((e)=>e=='B'); //Xoa theo dieu kien
  list1.clear;      //Xoa toan bo phan tu
  print (list1);
  //3 Truy cap phan tu
  print(list2[0]);  //Lap phan tu tai vi tri 0
  print(list2.first); //Lay phan tu dau tien
  print (list2.last );  // Lay phan tu cuoi cung
  print (list2.length);   //Do dai list
  //4 Kiem tra 
  print (list2.isEmpty);  //Kiem tra rong
  print ('List 3 : ${list3.isNotEmpty?'khong rong': 'rong'}');
  print (list4.contains('1'));
  print(list4.contains('0'));
  print (list4.indexOf(0));
  print(list4.lastIndexOf(0));
  //5 Bien doi
  list4 = [2,1,3,9,0,10];
  print (list4);
  list4.sort(); //sapxep tang dan
  print (list4);
  list4.reversed; //Dao nguoc
  print(list4.reversed);
  print (list4);
  //7 cat va noi
  var subList = list4.sublist(1,3);   //cat 1 sublist tu 1 den <3
  print (subList);
  var str_joined = list4.join(",");
  print (str_joined);

  //8 duyet cac phan tu ben trong list
  list4.forEach((element){
    print(element);
  });
  
}