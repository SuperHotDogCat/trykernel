#include <trykernel.h>

// entry追加関数
void tqueue_add_entry(TCB** queue, TCB* tcb){
    if (*queue == NULL){
        *queue = tcb;
        tcb->pre = tcb;
    } else {
        TCB* begin = *queue;
        TCB* end = begin->pre;
        end->next = tcb;
        tcb->pre = end;
        begin->pre = tcb;
    }
    tcb->next = NULL;
}

// 先頭entry削除関数
void tqueue_remove_top(TCB** queue){
    TCB *top;
    if (*queue == NULL) return;
    top = *queue;
    *queue = top->next;
    if (*queue != NULL){
        (*queue)->pre = top->pre;
    }
}

/* 指定エントリ削除関数 */
void tqueue_remove_entry(TCB **queue, TCB *tcb)
{
    if(*queue == tcb) {     // 指定したエントリはキューの先頭
        tqueue_remove_top(queue);
    } else {                // キューの途中から指定エントリを削除
        (tcb->pre)->next = tcb->next;
        if(tcb->next != NULL) {
            (tcb->next)->pre = tcb->pre;
        } else {
            (*queue)->pre = tcb->pre;
        }
    }
}

