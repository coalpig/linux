multiline.pattern: ^\[
多行正则表达式匹配 ^ [

multiline.negate: false

false匹配到的(主语negate)

ture为未匹配到的(主语negate)

| negate |  match |         Result          |
| ------ | -----: | :---------------------: |
| false  |  after | 匹配到的(主语negate)在未匹配到的的后面 |
| false  | before |  匹配到的(negate)在未匹配到的前面   |
| true   |  after |  未匹配到的(negate)在匹配到的后面   |
| true   | before |       未匹配到的在匹配到的前       |

multiline.match: after

未匹配到的或者未匹配到的(negate)在匹配到的后面


