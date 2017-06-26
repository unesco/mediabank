######################################################################
#
# Latest_tool Configuration
#
#  the latest_tool script is used to output the last "n" items 
#  accepted into the repository
#
######################################################################

$c->{latest_tool_modes} = {
	default => { 
        citation => "result" 
    },
    frontpage => {
        citation => "thumbnail",
        max => 4
    }
};