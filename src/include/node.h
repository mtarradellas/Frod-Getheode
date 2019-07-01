/*
 *    Credits to: @ChuOkupai
 *    https://github.com/ChuOkupai/n-ary-tree
 */

#ifndef _NODE_H

#include <stdlib.h>

typedef enum type {

  while_, lparen_, rparen_, lbrack_, rbrack_, if_, semicolon_, equal_, or_, and_, not_,
  isequal_, diff_, lthan_,lethan_, gthan_, gethan_, plus_, minus_, mult_, div_, mod_, 
  string_t_, int_t_, bool_t_, print_,  true_, false_, id_, int_, string_, notleaf_,
  main_, return_, scan_, comma_, empty_, exit_

} type;

static char * types[255] = {
  "while", "( ", ")", "{\n", " }\n", "if", ";\n", "= ", "|| ", "&& ", "! ",
  "== ", "!= ", "< ", "<= ", "> ", ">= ", "+ ", "- ", "* ", "/ ", "% ",
  "char * ", "int ","int ","printf", "1 ", "0 ","","","", "not Leaf ",
  "int main", "return ", "readStr", ", ", "", "exitProgram();"};

typedef struct Node Node;
struct Node {
  type type;
  char  * data;
  Node  * next;
  Node  * prev;
  Node  * parent;
  Node  * children;
};

/* Creates a new Node containing the given data type is notLeaf_*/
/** Returns NULL on error **/
Node * nodeNew(char * data);

/* Creates a new Node containing the given data and given type */
/** Returns NULL on error **/
Node * nodeTypeNew(char * data, type type);

/* Inserts a Node as the last child of the given parent */
/** Returns NULL on error **/
#define nodeAppend(parent, node)  nodeInsertBefore((Node *)parent, NULL, (Node *)node)

/* Inserts a Node beneath the parent before the given sibling */
/** If sibling is NULL, the node is inserted as the last child of parent **/
/** Returns NULL on error **/
Node * nodeInsertBefore(Node * parent, Node * sibling, Node * node);

/* Returns a positive value if a Node is the root of a tree else 0 */
#define nodeIsRoot(node)  (! ((Node *)(node))->parent && ! ((Node *)(node))->next)

/* Gets the root of a tree */
/** Returns NULL on error **/
Node * nodeRoot(Node * node);

/* Finds a Node in a tree */
Node * nodeFind(Node * node, void * data, int (* compare)(void * a, void * b));

/* Gets a child of a Node, using the given index */
/** Returns NULL if the index is too big **/
Node * nodeNthChild(Node * node, int n);

/* Gets the number of nodes in a tree */
int nodeTotal(Node  * root);

/* Unlinks a Node from a tree, resulting in two separate trees */
void  nodeUnlink(Node * node);

/* Removes root and its children from the tree, freeing any memory allocated */
void  nodeDestroy(Node * root);

int numberOfChildren(Node * node);

void printTree(Node * node);

void printHeaders();

#endif /* node.h */