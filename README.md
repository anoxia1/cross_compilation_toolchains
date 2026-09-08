# Smart_light 交叉编译工具链

本仓库保存 Smart_light 当前使用的 RK3588 和 RV1106 交叉编译工具链、
sysroot、RKNN 头文件及目标平台库。主仓库通过 `toolchain/` Git Submodule
固定本仓库的具体 commit。

## 目录

```text
cross_compilation_toolchains/
├── rk3588/
│   ├── aarch64-linux/       # aarch64-linux-gcc/g++ 及 GCC 运行时
│   ├── sysroot/             # RK3588 glibc sysroot、OpenCV、RKNN、RGA 等
│   └── include/             # RKNN 等平台头文件
└── rv1106/
    └── arm-rockchip830-linux-uclibcgnueabihf/
        ├── bin/             # RV1106 编译器
        ├── .../sysroot/     # RV1106 uClibc sysroot
        └── readme.txt       # 上游工具链安装说明
```

当前快照来自 Smart_light 主仓原 `toolchain/` 目录，包含约 10,000 个文件、
468 个符号链接，两个平台合计约 731 MB。大型编译器、库和 sysroot 文件由
Git LFS 管理；符号链接保持原样，避免破坏 GCC 和 sysroot 的相对路径。

## 获取

单独使用本仓库：

```bash
git clone https://github.com/anoxia1/cross_compilation_toolchains.git
cd cross_compilation_toolchains
git lfs pull
```

通过 Smart_light 获取：

```bash
git clone --recurse-submodules https://github.com/anoxia1/Smart_light.git
cd Smart_light
git submodule update --init --recursive
git -C toolchain lfs pull
```

如果只执行普通 `git clone`，LFS 文件可能只显示为 pointer；请安装 Git LFS
并执行 `git lfs pull`。主仓 CMake 需要保持本仓库挂载在 `toolchain/`，不要
将其移动到其他目录后再依赖隐式路径。

## 平台边界

- `rk3588/` 用于 RK3588/R6C 的 aarch64 glibc 构建。
- `rv1106/` 用于 RV1106 的 armhf/uClibc 构建。
- 工具链只提供编译和链接依赖，不代表对应平台的应用、NPU 模型或板端功能
  已完成验证。
- 工具链版本升级应先在本仓库提交并推送，再由 Smart_light 更新 Submodule
  指针并重新执行双平台构建验证。

## Git LFS 校验

维护或发布前执行：

```bash
git lfs fsck
git status --short
```

不要在未完成 LFS 上传的情况下更新 Smart_light 的 Submodule 指针。
