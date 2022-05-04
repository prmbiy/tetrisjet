#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <sys/time.h>
#include <ncurses.h>

using namespace std;

typedef struct {
    char **array;
    int width, row, col, sym;
} Shape;

void goUp();
void goDown();
void goRight();
void goLeft();
void rotAnti();
void rotClock();

#define onCollision() void onCollision_i(Shape &block)
#define onBlockSpawn() void onBlockSpawn_i(Shape &block)
#define onRowClear() void onRowClear_i(int count, int &score)
#define onLevelOver() void onLevelOver_i(int& score)
