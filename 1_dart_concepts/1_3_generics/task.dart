T maxInList<T extends Comparable>(List<T> list) {
  if (list.isEmpty) {
    throw ArgumentError('List cannot be empty');
  }

  T max = list.first;
  // list.skip(1) so that the loop starts from the second element, since I already set
  for (final element in list.skip(1)) {
    if (element.compareTo(max) > 0) {
      max = element;
    }
  }
  return max;
}

void main() {
  // Implement a method, returning the maximum element from a `Comparable` list.
  // You must use generics to allow different types usage with that method.
  print(maxInList<int>([1, 5, 3, 9, 2])); // 9
  print(maxInList<double>([2.5, 3.1, 0.9])); // 3.1
  print(maxInList<String>(['apple', 'pear', 'banana'])); // pear
}
