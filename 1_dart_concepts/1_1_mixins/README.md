Step 1.1: Mixins and extensions
===============================

**Estimated time**: 1 day




## Extensions

[Extension methods][11] is a vital concept in [Dart], allowing to add functionality to existing types in foreign libraries.

> For example, here’s how you might implement an extension on the `String` class:
> ```dart
> extension NumberParsing on String {
>   int parseInt() {
>     return int.parse(this);
>   }
>
>   double parseDouble() {
>     return double.parse(this);
>   }
> }
> ```

> ```dart
> print('42'.parseInt());
> ```

For better understanding of [extensions][11] design, benefits and use-cases, read through the following articles:
- [Dart Docs: Extension methods][11]
- [Lasse Reichstein Holst Nielsen: Dart Extension Methods Fundamentals][12]
- [Dart Language Spec: Dart Static Extension Methods Design][13]




## Mixins

[Mixins][21] in [Dart] represent a way of defining code that can be reused in multiple class hierarchies.

> ```dart
> mixin Musical {
>   bool canPlayPiano = false;
>   bool canCompose = false;
>   bool canConduct = false;
>
>   void entertainMe() {
>     if (canPlayPiano) {
>       print('Playing piano');
>     } else if (canConduct) {
>       print('Waving hands');
>     } else {
>       print('Humming to self');
>     }
>   }
> }
> ```

> ```dart
> class Maestro extends Person with Musical, Aggressive, Demented {
>   Maestro(String maestroName) {
>     name = maestroName;
>     canConduct = true;
>   }
> }
> ```

For better understanding of [mixins][21] design, benefits and use-cases, read through the following articles:
- [Dart Docs: Mixins][21]
- [Romain Rastel: Dart: What are mixins?][22]




## Task

- [`task_1.dart`](task_1.dart): implement an extension on `DateTime`, returning a `String` in format of `YYYY.MM.DD hh:mm`.
- [`task_2.dart`](task_2.dart): implement an extension on `String`, parsing links from a text.
- [`task_3.dart`](task_3.dart): provide mixins describing equipable `Item`s by a `Character` type, implement the methods equipping them.




## Questions

After completing everything above, you should be able to answer (and understand why) the following questions:
- **Why do you need to extend classes? Name some examples.**
- Extending classes means creating a child (subclass) from a parent (superclass).
The child class inherits properties and methods from the parent, and can:
Reuse code → no need to rewrite common logic.
Specialize behavior → override or add new methods.
Polymorphism → treat different objects through a common type.
This makes programs more modular, maintainable, and extensible.
Example,
class Animal {
  void speak() => print("Some sound...");
}
class Dog extends Animal {
  @override
  void speak() => print("Bark");
}
class Cat extends Animal {
  @override
  void speak() => print("Meow");
}
void main() {
  Animal a1 = Dog();
  Animal a2 = Cat();
  a1.speak(); // Bark
  a2.speak(); // Meow
}
Dog and Cat both extend Animal.
You can use them interchangeably as Animal because of polymorphism.
In Flutter, almost everything is based on extending classes:
StatelessWidget and StatefulWidget extend Widget.



- **Can extension be private? Unnamed? Generic?**
- Yes, In Dart, any identifier starting with _ is library-private (accessible only within the same file or library).
Ex,
extension _StringUtils on String {
  bool get isNumeric => RegExp(r'^\d+$').hasMatch(this);
}
void main() {
  print("123".isNumeric); // Works inside the same file
}
But _StringUtils won’t be available outside this file.
This is useful when you want helper extensions but don’t want to pollute the public API.
- Yes, Dart allows unnamed extensions. Instead of giving a name, you just write:
extension on String {
  String reversed() => split('').reversed.join();
}
void main() {
  print("hello".reversed()); // olleh
}
Good for quick helpers when you don’t need to reference the extension type directly.
(But you can’t use as imports with unnamed extensions, so naming is usually better in shared code.)
- Yes, You can write generic extensions using <T>.
Ex,
extension ListUtils<T> on List<T> {
  T? get firstOrNull => isEmpty ? null : first;
}
void main() {
  print([1,2,3].firstOrNull); // 1
  print(<String>[].firstOrNull); // null
}
This works for any type of list (List<int>, List<String>, etc.), making extensions powerful and reusable.



- **How to resolve naming conflicts when multiple extensions define the same methods?**
- If two extensions on the same type define the same method name, Dart gives a compile-time conflict error, because it doesn’t know which one to use.
Ex,
extension StringExt1 on String {
  String reversed() => split('').reversed.join();
}
extension StringExt2 on String {
  String reversed() => toUpperCase(); // Same method name "reversed"
}
void main() {
  String text = "dart";
  print(text.reversed()); // **Error: "reversed" is defined in multiple extensions**
}
There are 3 ways to avoid this conflict error:
**1) Explicit Import Prefix:** When you import both, use a prefix to disambiguate.
import 'string_ext1.dart' as ext1;
import 'string_ext2.dart' as ext2;
void main() {
  String text = "dart";
  print(ext1.StringExt1(text).reversed()); // Uses ext1
  print(ext2.StringExt2(text).reversed()); // Uses ext2
}
**2) Show/Hide in Imports:** Only the chosen extension is available, so no conflict.
import 'string_ext1.dart' show StringExt1;
import 'string_ext2.dart' hide StringExt2;
void main() {
  String text = "dart";
  print(text.reversed()); // Only StringExt1 available
}
**3) Rename Extension in Import:** If you own the code, avoid conflicts by using different method names or grouping logic into one extension.
import 'string_ext1.dart' as ext1;
import 'string_ext2.dart' as ext2;
void main() {
  String text = "dart";
  print(ext1.StringExt1(text).reversed()); // Uses ext1
}




- **What is reasoning behind mixins? Why would you need them? Provide some examples.**
- Mixins exist to solve code reuse without forcing you into the limitations of single inheritance.
In Dart, a class can extend only one superclass (single inheritance). But often, you want to reuse behavior across multiple unrelated classes (e.g., logging, serialization, validation, movement, etc.). Using Mixins, inject methods and fields into a class’s prototype without needing a parent-child relationship.
**Why You Need Mixins:**
**- Code Reuse Without Inheritance Problems:** Avoid deep, rigid hierarchies.
**- Multiple Behaviors:** You can combine many mixins into one class (with A, B, C).
**- Decoupling & Modularity:** Keeps behavior isolated in small, reusable blocks.
**Ex-1, Service and Repository share the same logging behavior without inheriting from the same base.**
mixin Logger {
  void log(String msg) => print("LOG: $msg");
}
class Service with Logger {}
class Repository with Logger {}
void main() {
  Service().log("Service started");
  Repository().log("Fetching data...");

}
**Ex-2, Both Duck and Superman reuse flying/swimming behavior without inheriting from a shared parent.**
mixin Fly {
  void fly() => print("I can fly!");
}
mixin Swim {
  void swim() => print("I can swim!");
}
class Duck with Fly, Swim {}
class Superman with Fly, Swim {}
void main() {
  Duck().fly();      // I can fly!
  Duck().swim();     // I can swim!
  Superman().fly();  // I can fly!
  Superman().swim(); // I can swim!
}


- **Can you add static methods and/or fields to mixins?**
- Yes, Dart allows static methods and static fields in mixins. But they belong to the mixin itself, not to the class that uses it. So we call it like MixinName.method() but not through the mixed-in class instance.
**Example-1: Static Method in a Mixin**
(Static methods do not transfer to the classes using the mixin. They stay namespaced under the mixin.)
mixin Logger {
  static void log(String msg) => print("LOG: $msg");
}
class Service with Logger {}
void main() {
  Service();              // Service mixed with Logger
  Logger.log("Started");  // works
  // Service.log("Test"); // ERROR: Service doesn’t get Logger’s static
}
**Example 2: Static Field in a Mixin**
(Static fields also remain accessible only via the mixin name, not through mixed-in classes.)
mixin Counter {
  static int count = 0;
  static void increment() => count++;
}
class MyClass with Counter {}
void main() {
  Counter.increment();
  print(Counter.count); // output: 1
  // MyClass.count;     // ERROR: Not available via MyClass
}
Dart keeps them in the mixin’s namespace to avoid conflicts. So, use static methods/fields in mixins as utilities for the mixin itself, not as part of the mixed-in class.




- **`class`, `mixin`, or `mixin class`? What are differences? When to use each one?**
**1) class:** 
The most common construct. Can have constructors, fields, instance methods, static methods, and inheritance. Used to create objects.
**Use:** Use class when you want to create a normal type that can be instantiated and extended.
Ex,
class Animal {
  void eat() => print("Animal is eating");
}
class Dog extends Animal {
  void bark() => print("Woof!");
}
void main() {
  Dog().eat();  // inherited
  Dog().bark(); // own method
}
**2) mixin:**
Special type intended only for code reuse, not for creating objects. No constructors allowed. Injects its methods/fields into another class. Cannot be instantiated directly.
**Use:** Use mixin when you want to share behavior across many classes without forcing inheritance.
Ex,
mixin Fly {
  void fly() => print("Flying...");
}
class Bird with Fly {}
void main() {
  Bird().fly(); // mixin behavior reused
  // Fly(); ERROR: cannot instantiate
}
**3) mixin class:**
Hybrid: behaves like both a class and a mixin. Can be used as a mixin OR instantiated like a class. Can also be extended.
**Use:** Use mixin class when you want a reusable type that works both like a normal class and like a mixin.
Ex,
mixin class Swimmer {
  void swim() => print("Swimming...");
}
class Fish extends Swimmer {}     // extends
class Human with Swimmer {}       // mixes in
void main() {
  Fish().swim();   // works
  Human().swim();  // works
  Swimmer().swim();// works. can be instantiated
}


  


[Dart]: https://dart.dev

[11]: https://dart.dev/language/extension-methods
[12]: https://medium.com/dartlang/extension-methods-2d466cd8b308
[13]: https://github.com/dart-lang/language/blob/main/accepted/2.7/static-extension-methods/feature-specification.md
[21]: https://dart.dev/language/mixins
[22]: https://medium.com/flutter-community/dart-what-are-mixins-3a72344011f3
