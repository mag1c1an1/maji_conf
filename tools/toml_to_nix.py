import tomllib  # Python 3.11+
import json
import re

def quote_key(key: str) -> str:
    """判断 key 是否需要加引号"""
    if re.match(r"^[A-Za-z_][A-Za-z0-9_']*$", key):
        return key
    else:
        return f'"{key}"'


def toml_to_nix(data, indent=0):
    """递归把 Python dict 转成 Nix Attribute Set 字符串"""
    space = "  " * indent
    out = []
    for key, value in data.items():
        k = quote_key(key)
        if isinstance(value, dict):
            nested = toml_to_nix(value, indent + 1)
            out.append(f"{space}{k} = {{\n{nested}{space}}};")
        elif isinstance(value, list):
            items = " ".join(to_nix_value(v) for v in value)
            out.append(f"{space}{k} = [ {items} ];")
        else:
            out.append(f"{space}{k} = {to_nix_value(value)};")
    return "\n".join(out) + "\n"


def to_nix_value(value):
    """将 Python 值转换成 Nix 表达式"""
    if isinstance(value, str):
        return json.dumps(value)  # 自动加双引号并转义
    elif isinstance(value, bool):
        return "true" if value else "false"
    elif value is None:
        return "null"
    elif isinstance(value, (int, float)):
        return str(value)
    elif isinstance(value, list):
        return "[ " + " ".join(to_nix_value(v) for v in value) + " ]"
    elif isinstance(value, dict):
        return "{ " + " ".join(f"{quote_key(k)} = {to_nix_value(v)};" for k, v in value.items()) + " }"
    else:
        raise TypeError(f"Unsupported type: {type(value)}")


if __name__ == "__main__":
    # 读取 TOML 文件
    with open("../nixos-wsl/shells/starship.toml", "rb") as f:
        data = tomllib.load(f)

    # 转换为 Nix Attribute Set 格式
    nix_text = "{\n" + toml_to_nix(data, 1) + "}"

    # 写入到文件
    with open("config.nix", "w") as f:
        f.write(nix_text)

    print("✅ 已生成 config.nix")
