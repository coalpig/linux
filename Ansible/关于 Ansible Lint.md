Ansible Lint 是一款命令行工具，用于检查**剧本、角色和集合**，适用于所有 Ansible 用户。其主要目标是推广经过验证的做法、模式和行为，同时避免容易导致错误或使代码更难维护的常见陷阱。

Ansible lint 还旨在帮助用户升级其代码以使用较新版本的 Ansible。因此，我们建议将其与最新版本的 Ansible 一起使用，即使生产中使用的版本可能较旧。

和其他 linter 一样，它有自己的一套规则。不过，它的规则是社区贡献的结果，每个用户都可以单独或按类别禁用它们。

[Ansible Galaxy 项目](https://github.com/ansible/galaxy/)利用此 linter 来计算[Galaxy Hub](https://galaxy.ansible.com/) 贡献内容的质量分数。这并不意味着此工具仅针对那些想要共享其代码的人。诸如 的文件`galaxy.yml`或诸如`galaxy_info` inside 的部分`meta.yml`有助于文档和维护，即使对于未发布的角色或集合也是如此。

[该项目最初由@willthames](https://github.com/willthames/)发起 ，后来被 Ansible 社区团队采用。其开发完全由社区驱动，同时与其他 Ansible 团队保持永久沟通。
