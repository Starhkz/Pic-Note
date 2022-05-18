void main(List<String> arguments) {
  String test = '[What is your name?]';
  int len = test.length;
  String a = test.substring(1, len - 1);
  Goat g = Goat('The Goat');
  file() {
    g.eat();
  }

  print(file());
}

class Animal {
  String name;
  Animal({required this.name});

  eat() {
    print('$name is eating');
  }

  grow() {
    print('$name is growing');
  }

  die() {
    print('$name dies');
  }

  live() {
    eat();
    grow();
    die();
  }
}

class Dog extends Animal {
  Dog(String name) : super(name: name);
}

class Cat extends Animal {
  Cat(String name) : super(name: name);
}

class Goat extends Animal {
  Goat(String name) : super(name: name);
}
