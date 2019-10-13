section .data

    message1:  db "Введите 10 символов:",0xa,0  ;сообщение вопроса, адрес начала строки
    ln1 equ $-message1                              ;длина сообщения
                                                    ;0xa - перенос строки
                                                    ;0 - не обязателен, но иногда может понадобиться, например при работе с C

message0: db 0xa                                    ;сообщение с переносом строки
ln0 equ $-message0

    enter: resb 10                                ;выделение памяти в 10 байт переменной enter
    lne equ $-enter                            ;длина сообщения


;начало самой программы
section .text
    global _start
    _start:


;действия для вывода содержимого
mov eax,4         ;номер функции
mov ebx,1         ;параметр №1 с обязательным номером
mov ecx, message1 ;параметр №2 с адресом первого символа переменной
mov edx, ln1      ;параметр №3 с количеством символов в переменной
int 0x80           ;запуск функции

;действия для ввода содержимого
mov eax, 3         ;номер функции для ввода
mov ebx, 0         ;параметр №1 с обязательным номером для ввода (const)
mov ecx, enter     ;параметр №2 с адресом первого символа enter
mov edx, lne       ;параметр №3 с количеством символов в переменной, остальные заполнятся нулями
int 0x80           ;запуск функции


;Особенности:
;ecx - двойное использование для адреса переменной и для подсчета в цикле
;будем использовать регистры esi и edi
;esi - для адреса
;edi - для подсчета циклов


;Алгоритм:
mov esi,ecx ; перенос адреса первого символа в esi
add esi,lne ; присвоение esi адреса последнего символа
mov edi,lne ; присвоение edi количество циклов
mov ecx,edi ; запускаем цикл, помещае в ecx количество проходов

Repeat:     ;ставим метку Repeat:
;действия для вывода содержимого
mov edi,ecx       ; помещаем количество циклов в edi
sub esi,1         ;уменьшаем адрес символа esi на 1
mov ecx,esi       ;помещаем в ecx новый адрес символа
mov eax,4         ;номер функции для вывода
mov ebx,1         ;параметр №1 с обязательным номером для вывода (const)
mov ecx,esi       ;параметр №2 с адресом первого символа переменной, помещаем в ecx адрес последнего символа
mov edx,1         ;параметр №3 с количеством символов в переменной, выводим один символ
int 0x80          ;запуск функции
mov esi,ecx       ;помещаем адрес следующего символа в esi
mov ecx,edi       ;помещаем в ecx количество проходов из edi
loop Repeat       ; повторяем цикл Repeat, при этом значение ecx уменьшается на 1

mov eax,4         ;номер функции для вывода
mov ebx,1         ;параметр №1 с обязательным номером для вывода (const)
mov ecx,message0  ;параметр №2 с адресом первого символа переменной, помещаем в ecx адрес последнего символа
mov edx,1         ;параметр №3 с количеством символов в переменной, выводим один символ
int 0x80          ;запуск функции

mov eax,1         ;номер функции для выхода из программы
int 0x80          ;запуск функции
