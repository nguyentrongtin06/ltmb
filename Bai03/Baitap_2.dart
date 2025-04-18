void main() {
  var set1 = {1, 2, 3};
  var set2 = {3, 4, 5};

  // Union (hợp)
  var unionSet = set1.union(set2);
  print(unionSet); // Output: {1, 2, 3, 4, 5}

  // Intersection (giao)
  var intersectionSet = set1.intersection(set2);
  print(intersectionSet); // Output: {3}

  // Difference (hiệu)
  var differenceSet = set1.difference(set2);
  print(differenceSet); // Output: {1, 2}
}