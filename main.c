#include <stdio.h>

struct apex{
    int x, y;
    int red, green, blue;
};

struct deltas{
    int x, xDelta, red, redDelta, green, greenDelta, blue, blueDelta;
};

// a-d/c-b
int interpolation(int a, int d, int c, int b)
{
    a = a-d;
    a = a * 256;
    c = c-b;
    if(c==0)
    {
        return 0;
    }
    a /= c;
    return a;
}

extern char* func(unsigned char* a, struct deltas*, struct deltas*, int, int);

int main()
{
    char header[] = {66, 77, 54, 0, 3, 0, 0, 0, 0, 0, 54, 0, 0, 0, 40, 0, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 1, 0, 24, 0, 0, 0, 0, 0, 0, 0, 3, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
    int size = 196608;
    char filename[] = "image.bmp";
    unsigned char data[size];
    struct apex a, b, c;
    a.x = 120;
    a.y = 220;
    a.red = 0;
    a.green = 255;
    a.blue = 0;
    b.x = 20;
    b.y = 20;
    b.red = 250;
    b.green = 0;
    b.blue = 0;
    c.x = 220;
    c.y = 19;
    c.red = 0;
    c.green = 0;
    c.blue = 255;

    // sortowanie
    if (a.y <= c.y)
    {
        struct apex temp = a;
        a = c;
        c = temp;
    }
    if (a.y <= b.y)
    {
        struct apex temp = b;
        b = a;
        a = temp;
    }
    if (b.y <= c.y)
    {
        struct apex temp = b;
        b = c;
        c = temp;
    }
    // wyznaczanie delt pionowych
    struct deltas left, right;
    // left
    left.xDelta = interpolation(a.x, b.x, a.y, b.y);
    left.x = a.x << 8;
    left.x += left.xDelta;

    left.redDelta = interpolation(a.red, b.red, a.y, b.y);
    left.red = a.red << 8;
    left.red += left.redDelta;

    left.greenDelta = interpolation(a.green, b.green, a.y, b.y);
    left.green = a.green << 8;
    left.green += left.greenDelta;

    left.blueDelta = interpolation(a.blue, b.blue, a.y, b.y);
    left.blue = a.blue << 8;
    left.blue += left.blueDelta;

    //right
    right.xDelta = interpolation(a.x, c.x, a.y, c.y);
    right.x = a.x << 8;
    right.x += right.xDelta;

    right.redDelta = interpolation(a.red, c.red, a.y, c.y);
    right.red = a.red << 8;
    right.red += right.redDelta;

    right.greenDelta = interpolation(a.green, c.green, a.y, c.y);
    right.green = a.green << 8;
    right.green += right.greenDelta;

    right.blueDelta = interpolation(a.blue, c.blue, a.y, c.y);
    right.blue = a.blue << 8;
    right.blue += right.blueDelta;

    // zeruję tablicę pikseli
    for (int i =0; i<size; i++)
    {
        data[i] = 0;
    }

    // printf("%p\n", (void * )data);
    char *r = func(data, &left, &right, a.y, b.y);
    FILE* fp;
    fp = fopen(filename, "w");
    fwrite(header, sizeof(header), 1, fp);
    fwrite(r, size, 1, fp);
    fclose(fp);
 
    return 0;
}
