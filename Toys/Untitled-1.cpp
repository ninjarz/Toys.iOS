1、判断一个无环单链表是否是回文的
输入：head指针
输出：如果是回文的，输出：true；否则：false
sample input：[]
sample output: true

链表结构体如下：
struct ListNode
{
    int val;
    NodeList *next;
    NodeList() : val(0), next(nullptr) {}
}

bool isPalindrome(ListNode* head)
{
    if (head)
    {
        // count
        int count = 0;
        ListNode* tmp = head;
        while (tmp)
        {
            ++count;
            tmp = tmp->next;
        }
        
        // reverse
        int odd = count % 2;
        count >>= 1;
        ListNode* pre = nullptr;
        ListNode* next = head->next;
        while (count--)
        {
            head->next = pre;
            
            pre = head;
            head = next;
            next = head->next;
        }
        if (!odd)
            next = head;
        
        // judge
        while (pre)
        {
            if (pre->val != next->val)
                return false;
            pre = pre->next;
            next = next->next;
        }
    }
    return true;
}
或者简单一点出单链表的反转，递归非递归，空间复杂度O(1)

2、LCA
输入：root指针
输出：LCA指针
sample input：root p q
            2(root)
      5(r)          3
1(p)      6(d)   7     8
sample output: r

struct TreeNode 
{
    int val;
    TreeNode *left;
    TreeNode *right;
    TreeNode(int x) : val(x), left(nullptr), right(nullptr) {}
};

TreeNode* lowestCommonAncestor(TreeNode* root, TreeNode* p, TreeNode* q)
{
    if (p == root || q == root)
        return root;
    
    TreeNode* result_left = root->left ? lowestCommonAncestor(root->left, p, q) : nullptr;
    TreeNode* result_right = root->right ? lowestCommonAncestor(root->right, p, q) : nullptr;
    if (result_left && result_right)
        return root;
    else if (result_left)
        return result_left;
    else if (result_right)
        return result_right;
    
    return nullptr;
}

3、Rader算法
输入：2^n  (n=0,1,2,3...)
输出：输出0到2^n-1的倒位序
sample input：8
sample output: 0 4 2 6 1 5 3 7

std::vector<int> EERader(int _count)
{
    if (_count <= 0)
        return std::vector<int>();
    
    std::vector<int> result(_count, 0);
    for (int i = 1; i < _count; ++i)
    {
        result[i] = (EERaderNext(_count, result[i - 1]));
    }
    
    return result;
}

int EERaderNext(int _count, int _value)
{
    if (_value < 0 || _count <= _value + 1)
        return 0;
    
    int pos = _count >> 1;
    while (pos <= _value)
    {
        _value -= pos;
        pos >>= 1;
    }
    
    return _value + pos;
}

输出 EERader(8);
可以问如果只要获取指定index位置的倒位序的值是什么，例如index＝＝3时，输出6
int EERader(int _count, int _index)
{
    int result = 0;
    
    for (int i(1), j(_count >> 1); i < _count; i <<= 1, j >>= 1)
    {
        if (_index & i)
        {
            result += j;
        }
    }
}

这是快速傅立叶变换的前置算法，可以接着深入问快速傅立叶算法