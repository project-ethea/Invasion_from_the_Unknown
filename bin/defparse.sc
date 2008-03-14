s/CAMPAIGN=//
s/^DOMAIN=.*//

# get rid of empty lines
1,/^./{
/./!d
}
:x
/./!{
N
s/^\n$//
tx
}
