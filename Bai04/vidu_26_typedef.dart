typedef IntList = List<int>;

typedef ListMapper<x> = Map<x, List<x>>;

void main(){
  IntList l1 = [1,2,3,4,5];
  print(l1);
  IntList l2 = [1,2,3,4,5,6,7];
  Map<String, List<String>> m1 ={};
  ListMapper<String> m2 = {};
}