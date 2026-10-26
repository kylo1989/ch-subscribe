import os
import urllib.request
import yaml

os.makedirs("output", exist_ok=True)

def fetch_lines(source):
    if source.startswith("http://") or source.startswith("https://"):
        req = urllib.request.Request(source, headers={'User-Agent': 'Mozilla/5.0'})
        with urllib.request.urlopen(req, timeout=30) as resp:
            content = resp.read().decode('utf-8')
    else:
        with open(source, 'r', encoding='utf-8') as f:
            content = f.read()

    # 尝试按 YAML 解析，若失败则按纯文本 .list 解析
    try:
        data = yaml.safe_load(content)
        if isinstance(data, dict) and 'payload' in data:
            return [str(line).strip() for line in data['payload'] if line]
    except Exception:
        pass
    return [line.strip() for line in content.splitlines() if line.strip() and not line.strip().startswith('#')]

with open("sources.txt", "r", encoding="utf-8") as f:
    sources = [line.strip() for line in f if line.strip() and not line.startswith("#")]

for item in sources:
    name, url = item.split("|", 1)
    lines = fetch_lines(url)

    domains, ipcidrs, classicals = [], [], []

    for line in lines:
        # 去除行内注释
        line = line.split('#')[0].strip()
        if not line:
            continue
        parts = [p.strip() for p in line.split(',')]
        if len(parts) < 2:
            continue

        rule_type = parts[0].upper()
        value = parts[1]

        if rule_type == 'DOMAIN':
            domains.append(value)
        elif rule_type == 'DOMAIN-SUFFIX':
            domains.append(f"+.{value}")
        elif rule_type in ('IP-CIDR', 'IP-CIDR6'):
            ipcidrs.append(value)
        else:
            # 保留 DOMAIN-KEYWORD, PROCESS-NAME, USER-AGENT 等无法转 mrs 的规则
            classicals.append(line)

    if domains:
        with open(f"output/{name}_domain.yaml", "w", encoding="utf-8") as out:
            yaml.dump({"payload": domains}, out, allow_unicode=True)
    if ipcidrs:
        with open(f"output/{name}_ipcidr.yaml", "w", encoding="utf-8") as out:
            yaml.dump({"payload": ipcidrs}, out, allow_unicode=True)
    if classicals:
        with open(f"output/{name}_classical.yaml", "w", encoding="utf-8") as out:
            yaml.dump({"payload": classicals}, out, allow_unicode=True)
