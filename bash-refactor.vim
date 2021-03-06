function! BashMakeFunction()
    " save the name under curson in the "a" register
    normal! "ayiw
    " write the function
    " start inserting above the line
    normal! O
    " paste the name of the function (from the "a" register)
    " now we have: function-name
    normal! "ap
    " append the "()" and the "{"
    " now we have: function-name() {
    normal! a() {
    " add a line with the semicolon (null command in Bash)
    " now we have: 
    "   function-name() {
    "   :
    normal! o:
    " add the closing brace
    " now we have:
    "   function-name() {
    "       :
    "       }
    normal! o}
    " dedent if necessary the closing brace
    " now we have:
    "   function-name() {
    "       :
    "   }
    normal! <<
endfunction

nnoremap ,mf :call BashMakeFunction()<cr>

function! BashExtractVariable()
    let name = input("Variable name: ")
    if name == ''
        return
    endif
    " Enter visual mode (not sure why this is needed since we're already in
    " visual mode anyway)
    normal! gv

    " Replace selected text with the variable name
    exec "normal c$" . name
    " Define the variable on the line above
    exec "normal! O" . name . "="
    " Paste the original selected text to be the variable value
    normal! $p
endfunction
vnoremap ,rv :call BashExtractVariable()<cr>

function! BashInlineVariable()
    " Copy the variable under the cursor into the 'a' register
    " XXX: How do I copy into a variable so I don't pollute the registers?
    :normal "ayiw
    " It takes 4 diws to get the variable, equal sign, and surrounding
    " whitespace. I'm not sure why. diw is different from dw in this respect.
    :normal df=
    " Delete the expression into the 'b' register
    :normal "bd$
    " Delete the remnants of the line
    :normal dd
    " Go to the end of the previous line so we can start our search for the
    " usage of the variable to replace. Doing '0' instead of 'k$' doesn't
    " work; I'm not sure why.
    " normal k$
    " Find the next occurence of the variable
    exec '/$\<' . @a . '\>'
    " Replace that occurence with the text we yanked
    exec ':.s/$\<' . @a . '\>/' . @b
endfunction
nnoremap ,ri :call BashInlineVariable()<cr>

