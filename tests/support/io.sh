#! /bin/bash
acceptance_title()
{
    echo -e "\e[1m\e[90m--- Run acceptation for: $1 ---\e[0m"
}

story_title()
{
    echo -e "\e[90m------> Run story: $1\e[0m"
}

story_description()
{
    echo -e "\e[37m          > $1\e[0m"
}