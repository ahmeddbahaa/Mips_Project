#include <stdio.h>
#include <stdlib.h>
#include <string.h>
/**
 *
 @author AhmedBahaa
 *
 **/

typedef struct request
{
    char data[100];
    int priority;
} Request;

int currentListSize[4] = {0, 0, 0, 0};
Request requestList[4][20];

//Ahmed bahaa
void printingMenu();
void quickSort_all();
//omar yehia 
void quickSort(Request[20], int q, int r);
int partition(Request[20], int q, int r);
//adham & attia
int validate(Request mid, Request target);
int binary_search(Request target, int);
int binarySearch_all(Request);
void Empty_all();
//eslam
void Process_all(Request target);
void Delete_all(Request target);
int input();
//Mostafa
void Delete(Request target, int k);
void menu();

int main(void)
{
    menu();
}

//functions
void printingMenu()
{
    printf("Enter a Valid Number of the Menus \n");
    printf("1- Search for Request by Priority \n");
    printf("2- Delete all Requests of same Priority \n");
    printf("3- Process all Requests of same Priority \n");
    printf("4- Empty All lists \n");
    printf("5- Insert Requests \n");
    printf("-1 to end the program\n");
}
void menu()
{
    int inputValue = 0;
    printingMenu();
    scanf("%d", &inputValue);
    Request request;
    while (inputValue != -1)
    {
        if (inputValue == 1)
        {
            printf("Enter The Request Priority that you wish to search : \n");
            scanf("%d", &request.priority);
            int found = binarySearch_all(request);
            if (found != -1)
            {
                int x = binary_search(request, found);
                printf("your Request is Found in list %d of index %d  of priority value %d and data %s \n"
                , found, x, requestList[found][x].priority, requestList[found][x].data);
            }
            else
            {
                printf("%s", "Not Found\n");
            }
        }
        if (inputValue == 2)
        {
            printf("Enter The Request Priority that you wish to Delete \n");
            scanf("%d", &request.priority);
            Delete_all(request);
        }
        else if (inputValue == 3)
        {
            printf("Enter The Request Priority that you wish to Process \n");
            scanf("%d", &request.priority);
            Process_all(request);
        }
        else if (inputValue == 4)
        {
            Empty_all();
        }
        else if (inputValue == 5)
        {
            input();
        }
        else
        {
            printf("Please Enter Valid menu\n");
        }
        printingMenu();
        scanf("%d", &inputValue);
    }
}
int binarySearch_all(Request target)
{
    for (int i = 0; i < 4; i++)
    {
        int x = binary_search(target, i);
        if (x != -1)
        {
            return i;
        }
    }
    return -1;
}
int input()
{
    int inputSize = 0, i = 0;
    Request request;
    printf("enetr input size : ");
    scanf("%d", &inputSize);
    for (int j = 0; j < inputSize; j++)
    {
        printf("Enter your Request Priority then your Request Data \n");
        scanf("%d %[^\n]%*c", &request.priority, request.data);
        int flag = 1;
        while (flag != 0 && i != 4)
        {
            if (currentListSize[i] < 20)
            {
                requestList[i][currentListSize[i]] = request;
                currentListSize[i]++;
                flag = 0;
            }
            else
            {
                i++;
            }
        }
        if (i == 4)
            return -1;
    }
    return 1;
}
int validate(Request mid, Request target)
{
    if (mid.priority == target.priority)
    {
        return 1;
    }
    else if (mid.priority < target.priority)
    {
        return 0;
    }
    else
    {
        return -1;
    }
}
int binary_search(Request target, int k)
{
    int st = 0, end = currentListSize[k];
    int mid = 0;
    while (st < end)
    {
        mid = st + (end - st) / 2;
        int validateValue = validate(requestList[k][mid], target);
        if (validateValue == 1)
        {
            end = mid;
        }
        else if (validateValue == 0)
        {
            st = mid + 1;
        }
        else
        {
            end = mid - 1;
        }
    }
    if (requestList[k][st].priority == target.priority)
    {
        return st;
    }
    else
    {
        return -1;
    }
}

void quickSort_all()
{
    for (int i = 0; i < 4; i++)
    {
        quickSort(&requestList[i][0], 0, currentListSize[i] - 1);
    }
}
void quickSort(Request a[], int p, int r)
{
    if (p < r)
    {
        int q = partition(a, p, r);
        quickSort(a, p, q - 1);
        quickSort(a, q + 1, r);
    }
}
int partition(Request a[], int p, int r)
{
    int x = a[r].priority, i = p - 1;
    for (int j = p; j <= r - 1; j++)
    {
        if (a[j].priority <= x)
        {
            i++;
            Request temp = a[i];
            a[i] = a[j];
            a[j] = temp;
        }
    }
    Request temp = a[i + 1];
    a[i + 1] = a[r];
    a[r] = temp;
    return i + 1;
}

void Empty_all()
{
    for (int i = 0; i < 4; i++)
    {
        for (int j = 0; j < currentListSize[i]; j++)
        {
            requestList[i][j].priority = 0;
        }
        currentListSize[i] = 0;
    }
}
void Delete(Request target, int k)
{
    int i;
    int x = binary_search(target, k);
    if (x != -1)
    {
        for (i = x; i < 20; i++)
        {
            requestList[k][i] = requestList[k][i + 1];
        }
    }
}
void Delete_all(Request target)
{
    for (int i = 0; i < 4; i++)
    {
        quickSort_all();
        int x = binary_search(target, i);
        while (x != -1)
        {
            Delete(target, i);
            currentListSize[i]--;
            //quickSort_all();
            x = binary_search(target, i);
        }
    }
}
void Process_all(Request target)
{
    int count = 0;
    for (int i = 0; i < 4; i++)
    {
        quickSort_all();
        int x = binary_search(target, i);
        while (x != -1)
        {
            printf("Processing Request  %d of value %s\n", requestList[i][x].priority, requestList[i][x].data);
            Delete(target, i);
            currentListSize[i]--;
            //quickSort_all();
            count++;
            x = binary_search(target, i);
        }
        if (count == 0)
            printf("No Requests found with priority %d in list %d \n", target.priority, i);
    }
}
