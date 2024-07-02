function insert-date-time ()
{
    # add (+=) current date and time to cursor position (C-2)
    # compact readable form of iso8601
    LBUFFER+="$(date +'%Y%m%d_%H%M%S')"
}


function insert-epoch ()
{
    LBUFFER+="$(date +'%s')"
}
