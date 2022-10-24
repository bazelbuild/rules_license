#include <iostream>
#include <ostream>

extern const char* server_message;
extern void lib_level_4();

int main(int argc, char* argv[]) {
  std::cout << "main" << std::endl;
  lib_level_4();
  return 0;
}
