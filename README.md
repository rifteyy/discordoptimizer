# discordoptimizer
Debloat and optimize Discord Stable, Discord Canary, Discord PTB. Was also used in my portfolio for school application (:

![alt text](https://media.discordapp.net/attachments/869861284621979681/1203399845843566652/lht21bt.png?ex=65d0f471&is=65be7f71&hm=ea0e6c4a50e3a1b9fd77fa2a69e88a7aeaac5991b2742eae73697b8165d905ab&=&format=webp&quality=lossless&width=2037&height=1137)

### What can it do?
1) Debloat - clears all unnecessary modules, Discord can fully work without them
2) Clears unused languages - clears all languages except the one in variable `keepLanguage` on line 3, which on default contains `en-US`, though it can be changed (NOTE: trying to set a cleared language will result in Discord simply downloading it)
3) Clear log, old installations, crash reports - clears all logs, packages and temporary files that Discord creates
4) Optimize priority - optimizes Discord priority either to low, or high, also can be resetted to default (normal)
5) Clear old application versions - automatically scans all the Discord versions and decides which is the latest and deletes every except the latest one. (NOTE: unable to use for Discord PTB, Discord Canary)
6) Clear cache - clears all files in Cache, GPUCache, Code Cache folders
7) Disable Start-Up run - deletes the registry key that causes it to launch at start (NOTE: can not be reversed)






### How to use?
1) Just download the main.bat and launch it by double click
2) Select the version you would like to optimize
3) Apply the optimizations
4) Launch Discord using the icon or module 8 - Restart Discord

### What if it broke my Discord?
I honestly don't think that is possible but if you think so, easiest thing to do is just uninstall Discord, download new setup and install again.

### Does it interfere with Vencord, BetterDiscord etc.?
No. You can use BetterDiscord, Vencord and other modifications without them being disabled. 
