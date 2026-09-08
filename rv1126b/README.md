# RV1126B 交叉工具链

本目录是从 Neardi LKB1126BP SDK 的 Buildroot 输出中提取的 RV1126B
64 位交叉编译工具链与目标开发 sysroot，服务于 Smart_light 的
`rv1126b/rv1126bp` 构建配置。

## 来源

| 项目 | 内容 |
| --- | --- |
| SDK | `Neardi-LKB1126BP-SDK-Linux-v1.2` |
| SDK Git 提交 | `3005c13` |
| Buildroot 输出 | `rockchip_rv1126b` |
| 目标三元组 | `aarch64-buildroot-linux-gnu` |
| C 库 | Buildroot glibc |
| GCC | 13.3.0 |
| CPU 默认参数 | Cortex-A53 / ARMv8-A |
| RKNN Runtime | `librknnrt.so` |

## 目录布局

```text
rv1126b/
├── bin/                              # Buildroot wrapper 与目标工具
├── lib/gcc/aarch64-buildroot-linux-gnu/13.3.0/
├── libexec/gcc/aarch64-buildroot-linux-gnu/13.3.0/
└── aarch64-buildroot-linux-gnu/
    ├── bin/                          # target binutils
    ├── include/                      # target 头文件搜索目录
    ├── lib/                          # linker scripts
    ├── lib64/                        # GCC runtime
    └── sysroot/                      # 目标开发 sysroot
```

SDK 中与本项目交叉编译无关的 Qt、LLVM、Vulkan、GStreamer、Perl 等大体积
组件未提取。sysroot 保留了 glibc/C++ 基础运行库、ALSA、RGA、DRM、udev、
zlib、RKNN Runtime 及对应头文件。

## 编译器自检

在仓库根目录执行：

```bash
toolchain/rv1126b/bin/aarch64-buildroot-linux-gnu-gcc -dumpmachine
toolchain/rv1126b/bin/aarch64-buildroot-linux-gnu-gcc -print-sysroot
```

预期分别为：

```text
aarch64-buildroot-linux-gnu
.../toolchain/rv1126b/aarch64-buildroot-linux-gnu/sysroot
```

该目录使用普通 Git 文件，不使用 Git LFS。若重新从 SDK 提取，必须先核对
SDK 配置为 `rv1126bp + arm64`，并同步更新本文件中的来源提交和主仓
`toolchain/` 子模块指针。
