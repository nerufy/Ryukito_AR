# ARサバイバルゲーム「A-RSoft」
## 「DS_Store」を含めないで
### 無効化手順
```bash
$ cd
$ vi .gitignore_global
```
vi起動後、以下のように追記して保存
```.gitignore_global
*~
.DS_Store
```
保存後以下を実行
```bash
$ git config --global core.excludesfile ~/.gitignore_global
```
### 参考
- https://git-scm.com/book/ja/v2/Git-%E3%81%AE%E3%82%AB%E3%82%B9%E3%82%BF%E3%83%9E%E3%82%A4%E3%82%BA-Git-%E3%81%AE%E8%A8%AD%E5%AE%9A
