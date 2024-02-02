# Rugpi Extra

**Additional recipes and layers for [Rugpi](https://rugpi.io).**

To make the recipes and layers available, include the following in your `rugpi-bakery.toml`:

```toml
[repositories]
rugpi-extra = { git = "https://github.com/silitics/rugpi-extra.git", branch = "v0.6" }
```

We follow [Cargo's flavor of semantic versioning](https://doc.rust-lang.org/cargo/reference/resolver.html#semver-compatibility).
You can also use the most recent development version by omitting the `branch` property.
Please be aware that this may break your builds if we introduce backwards-incompatible changes.

## 🙌 Contributions

We accept pull requests adding additional recipes to `rugpi-extra` under the condition that these recipes are sufficiently general and widely applicable.
Please do not submit recipes for your own specific applications.
For those, you should create a separate repository yourself.
If you are unsure, feel free to open an issue.

## ⚖️ Licensing

This project is licensed under either [MIT](https://github.com/silitics/rugpi/blob/main/LICENSE-MIT) or [Apache 2.0](https://github.com/silitics/rugpi/blob/main/LICENSE-APACHE) at your opinion.

Unless you explicitly state otherwise, any contribution intentionally submitted for inclusion in this project by you, as defined in the Apache 2.0 license, shall be dual licensed as above, without any additional terms or conditions.

---

Made with ❤️ for OSS by [Silitics](https://www.silitics.com)
