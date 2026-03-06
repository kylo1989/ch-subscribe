const SUBUpdateTime = 6; // 单位小时
const regex = /^(\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}|\[.*\]):?(\d+)?#?(.*)?$/;
export default {
    async fetch(request, env, ctx) {
        let subProtocol = 'https';
        let subConverter = env.SUBAPI || 'sUBaPI.cMlIUSSSS.nET';
        if (subConverter.includes("http://")) {
            subConverter = subConverter.split("//")[1];
            subProtocol = 'http';
        } else {
            subConverter = subConverter.split("//")[1] || subConverter;
        }
        let subConfig = env.SUBCONFIG || 'https://raw.githubusercontent.com/ACL4SSR/ACL4SSR/master/Clash/config/ACL4SSR_Online_Mini_MultiMode.ini';
        let ips = ['3Q.bestip-one.cf.090227.xyz#加入我的频道t.me/CMLiussss解锁更多优选节点'];
        if (env.ADD) ips = await 整理成数组(env.ADD);
        let FileName = env.SUBNAME || 'BPSUB';
        let EndPS = env.PS || '';

        const url = new URL(request.url);
        // 获取和处理 host 参数
        let hosts = [];
        if (url.searchParams.has('host')) {
            hosts = url.searchParams.get('host').split('|').filter(host => host.trim());
        } else if (env.HOST) {
            hosts = await 整理成数组(env.HOST);
            hosts = hosts.filter(host => host && host.trim());
        }
        let bphost = hosts.length > 0 ? hosts[Math.floor(Math.random() * hosts.length)].trim() : null;
        const UA = request.headers.get('User-Agent') || 'null';
        const userAgent = UA.toLowerCase();
        const 需要订阅转换的UA = ['clash', 'meta', 'mihomo', 'sing-box', 'singbox'];
        // 检查是否来自订阅转换后端的请求
        const isSubConverterRequest = request.headers.get('subconverter-request') ||
            request.headers.get('subconverter-version') ||
            userAgent.includes('subconverter');

        const subapiList = [{
            label: `🛡️ ${FileName}-默认内置后端`,
            value: `${subProtocol}://${subConverter.toLowerCase()}`
        }, {
            label: '🔄 CM提供-负载均衡后端',
            value: 'https://subapi.fxxk.dedyn.io'
        }, {
            label: '🚀 周润发提供-后端',
            value: 'https://subapi.zrfme.com'
        }, {
            label: '🐑 肥羊提供-增强型后端',
            value: 'https://url.v1.mk'
        }, {
            label: '🎭 肥羊提供-备用后端',
            value: 'https://sub.d1.mk'
        }];

        if (url.pathname === '/sub') {
            if (!bphost) {
                return new Response(JSON.stringify({
                    error: '请提供有效的 host 参数',
                    message: '可以通过 URL 参数 ?host=域名 或环境变量 HOST 提供'
                }), {
                    status: 400,
                    headers: { 'Content-Type': 'application/json; charset=utf-8' },
                });
            } else if (bphost.includes("*")) bphost = bphost.replace("*", Date.now().toString());

            subConverter = (url.searchParams.has('subapi') && url.searchParams.get('subapi') !== 'default') ? url.searchParams.get('subapi') : subConverter;
            if (subConverter.includes("http://")) {
                subConverter = subConverter.split("//")[1];
                subProtocol = 'http';
            } else {
                subConverter = subConverter.split("//")[1] || subConverter;
            }
            subConfig = (url.searchParams.has('subconfig') && url.searchParams.get('subconfig') !== 'default') ? url.searchParams.get('subconfig') : subConfig;
            const trojan = url.searchParams.get('trojan') || false;
            const uuid = url.searchParams.get('uuid') || env.UUID;
            const uuid_json = await getLocalData(bphost, uuid);
            const xhttp = url.searchParams.get('xhttp') || false;
            const initialProxyIP = url.searchParams.has('proxyip') ? url.searchParams.get('proxyip') : env.PROXYIP || null;
            const proxyIP = (initialProxyIP && initialProxyIP.includes('.william')) ? (await 解析William域名(initialProxyIP)) || initialProxyIP : initialProxyIP;
            let 最终路径 = (proxyIP && proxyIP.trim?.() !== '') ? `/proxyip=${proxyIP}` : `/`;
            let socks5 = null;
            const 全局socks5 = (url.searchParams.has('global')) ? true : false;
            if (url.searchParams.has('socks5') && url.searchParams.get('socks5') != '') {
                socks5 = url.searchParams.get('socks5');
                最终路径 = 全局socks5 ? `/socks5://${socks5}` : `/socks5=${socks5}`;
            } else if (url.searchParams.has('http') && url.searchParams.get('http') != '') {
                socks5 = url.searchParams.get('http');
                最终路径 = 全局socks5 ? `/http://${socks5}` : `/http=${socks5}`;
            }

            if (url.searchParams.has('ed') && url.searchParams.get('ed') != '') 最终路径 += `?ed=${url.searchParams.get('ed')}`;
            const 跳过证书验证 = (url.searchParams.has('scv')) ? true : false;

            const responseHeaders = {
                "content-type": "text/plain; charset=utf-8",
                "Profile-Update-Interval": `${SUBUpdateTime}`,
                "Profile-web-page-url": url.origin,
            };

            if (url.searchParams.has('sub') && url.searchParams.get('sub').trim() !== '') {
                const 优选订阅生成器 = url.searchParams.get('sub').trim();

                const randomIndex = Math.floor(Math.random() * uuid_json.length);
                const selected = uuid_json[randomIndex];
                const uuid = selected.uuid;
                const 伪装域名 = selected.host;
                const 验证字段名 = trojan ? 'password' : 'uuid';
                let subConverterUrl = `https://${优选订阅生成器}/sub?${验证字段名}=${uuid}&host=${伪装域名}&path=${encodeURIComponent(最终路径)}`;
                if (需要订阅转换的UA.some(ua => userAgent.includes(ua)) &&
                    !userAgent.includes(('CF-Workers-SUB').toLowerCase()) &&
                    !isSubConverterRequest) {

                    responseHeaders["Content-Disposition"] = `attachment; filename*=utf-8''${encodeURIComponent(FileName)}`;
                    //console.log(subConverterUrl);
                    if (userAgent.includes('sing-box') || userAgent.includes('singbox')) {
                        subConverterUrl = `${subProtocol}://${subConverter}/sub?target=singbox&url=${encodeURIComponent(subConverterUrl)}&insert=false&config=${encodeURIComponent(subConfig)}&emoji=true&list=false&tfo=false&scv=${跳过证书验证}&fdn=false&sort=false&new_name=true`;
                    } else if (userAgent.includes('clash') || userAgent.includes('meta') || userAgent.includes('mihomo')) {
                        subConverterUrl = `${subProtocol}://${subConverter}/sub?target=clash&url=${encodeURIComponent(subConverterUrl)}&insert=false&config=${encodeURIComponent(subConfig)}&emoji=true&list=false&tfo=false&scv=${跳过证书验证}&fdn=false&sort=false&new_name=true`;
                    } else {
                        subConverterUrl = `${subProtocol}://${subConverter}/sub?target=auto&url=${encodeURIComponent(subConverterUrl)}&insert=false&config=${encodeURIComponent(subConfig)}&emoji=true&list=false&tfo=false&scv=${跳过证书验证}&fdn=false&sort=false&new_name=true`;
                    }
                }

                try {
                    const subConverterResponse = await fetch(subConverterUrl, { headers: { 'User-Agent': `v2rayN/${FileName} (https://github.com/cmliu/CF-Workers-BPSUB)` } });

                    if (!subConverterResponse.ok) {
                        const errorDetails = {
                            error: "SubConverter请求失败",
                            message: `订阅转换服务返回错误状态`,
                            details: {
                                status: subConverterResponse.status,
                                statusText: subConverterResponse.statusText,
                                url: subConverterUrl,
                                headers: Object.fromEntries(subConverterResponse.headers.entries()),
                                userAgent: UA,
                                timestamp: new Date().toISOString()
                            }
                        };

                        // 尝试获取错误响应内容
                        try {
                            const errorText = await subConverterResponse.text();
                            if (errorText) {
                                errorDetails.details.responseBody = errorText.substring(0, 1000); // 限制长度
                            }
                        } catch (textError) {
                            errorDetails.details.responseBodyError = textError.message;
                        }

                        return new Response(JSON.stringify(errorDetails, null, 2), {
                            status: subConverterResponse.status,
                            headers: { 'content-type': 'application/json; charset=utf-8' },
                        });
                    }

                    const responseBody = await subConverterResponse.text();
                    const 返回订阅内容 = userAgent.includes(('Mozilla').toLowerCase()) ? atob(responseBody) : responseBody;

                    if (!userAgent.includes(('Mozilla').toLowerCase())) responseHeaders["Content-Disposition"] = `attachment; filename*=utf-8''${encodeURIComponent(FileName + '-' + 优选订阅生成器)}`;
                    return new Response(返回订阅内容, { headers: responseHeaders });
                } catch (error) {
                    const errorDetails = {
                        error: "SubConverter连接异常",
                        message: `无法连接到订阅转换服务或处理响应时发生错误`,
                        details: {
                            errorType: error.name || 'UnknownError',
                            errorMessage: error.message,
                            url: subConverterUrl,
                            userAgent: UA,
                            timestamp: new Date().toISOString(),
                            stack: error.stack ? error.stack.substring(0, 500) : undefined
                        }
                    };

                    return new Response(JSON.stringify(errorDetails, null, 2), {
                        status: 500,
                        headers: { 'content-type': 'application/json; charset=utf-8' },
                    });
                }
            } else {
                if (需要订阅转换的UA.some(ua => userAgent.includes(ua)) &&
                    !userAgent.includes(('CF-Workers-SUB').toLowerCase()) &&
                    !isSubConverterRequest) {

                    let subConverterUrl = url.href;
                    if (userAgent.includes('sing-box') || userAgent.includes('singbox')) {
                        subConverterUrl = `${subProtocol}://${subConverter}/sub?target=singbox&url=${encodeURIComponent(subConverterUrl)}&insert=false&config=${encodeURIComponent(subConfig)}&emoji=true&list=false&tfo=false&scv=${跳过证书验证}&fdn=false&sort=false&new_name=true`;
                    } else if (userAgent.includes('clash') || userAgent.includes('meta') || userAgent.includes('mihomo')) {
                        subConverterUrl = `${subProtocol}://${subConverter}/sub?target=clash&url=${encodeURIComponent(subConverterUrl)}&insert=false&config=${encodeURIComponent(subConfig)}&emoji=true&list=false&tfo=false&scv=${跳过证书验证}&fdn=false&sort=false&new_name=true`;
                    } else {
                        subConverterUrl = `${subProtocol}://${subConverter}/sub?target=auto&url=${encodeURIComponent(subConverterUrl)}&insert=false&config=${encodeURIComponent(subConfig)}&emoji=true&list=false&tfo=false&scv=${跳过证书验证}&fdn=false&sort=false&new_name=true`;
                    }

                    try {
                        const subConverterResponse = await fetch(subConverterUrl, { headers: { 'User-Agent': `v2rayN/${FileName} (https://github.com/cmliu/CF-Workers-BPSUB)` } });

                        if (!subConverterResponse.ok) {
                            const errorDetails = {
                                error: "SubConverter请求失败",
                                message: `订阅转换服务返回错误状态`,
                                details: {
                                    status: subConverterResponse.status,
                                    statusText: subConverterResponse.statusText,
                                    url: subConverterUrl,
                                    headers: Object.fromEntries(subConverterResponse.headers.entries()),
                                    userAgent: UA,
                                    timestamp: new Date().toISOString()
                                }
                            };

                            // 尝试获取错误响应内容
                            try {
                                const errorText = await subConverterResponse.text();
                                if (errorText) {
                                    errorDetails.details.responseBody = errorText.substring(0, 1000); // 限制长度
                                }
                            } catch (textError) {
                                errorDetails.details.responseBodyError = textError.message;
                            }

                            return new Response(JSON.stringify(errorDetails, null, 2), {
                                status: subConverterResponse.status,
                                headers: { 'content-type': 'application/json; charset=utf-8' },
                            });
                        }

                        let subConverterContent = await subConverterResponse.text();

                        responseHeaders["Content-Disposition"] = `attachment; filename*=utf-8''${encodeURIComponent(FileName)}`;
                        return new Response(subConverterContent, { status: 200, headers: responseHeaders });
                    } catch (error) {
                        const errorDetails = {
                            error: "SubConverter连接异常",
                            message: `无法连接到订阅转换服务或处理响应时发生错误`,
                            details: {
                                errorType: error.name || 'UnknownError',
                                errorMessage: error.message,
                                url: subConverterUrl,
                                userAgent: UA,
                                timestamp: new Date().toISOString(),
                                stack: error.stack ? error.stack.substring(0, 500) : undefined
                            }
                        };

                        return new Response(JSON.stringify(errorDetails, null, 2), {
                            status: 500,
                            headers: { 'content-type': 'application/json; charset=utf-8' },
                        });
                    }
                }

                if (url.searchParams.has('ips') && url.searchParams.get('ips').trim() !== '') ips = await 整理成数组(url.searchParams.get('ips'));

                const 标题 = `${url.hostname}:443#${FileName} 订阅到期时间 ${getDateString()}`;
                let add = [];
                let addapi = env.ADDAPI ? await 整理成数组(env.ADDAPI) : [];
                for (const ip of ips) {
                    if (ip.startsWith('http') && ip.includes('://')) {
                        addapi.push(ip);
                    } else {
                        add.push(ip);
                    }
                }

                const newAddapi = await 整理优选列表(addapi, FileName);
                // 将newAddapi数组添加到add数组,并对add数组去重
                add = [...new Set([...add, ...newAddapi])];

                const responseBody = add.map(address => {
                    let port = "443";
                    let addressid = address;

                    const match = addressid.match(regex);
                    if (!match) {
                        if (address.includes(':') && address.includes('#')) {
                            // 找到第一个冒号和第一个井号的位置
                            const colonIndex = address.indexOf(':');
                            const hashIndex = address.indexOf('#');

                            const originalAddress = address;
                            address = originalAddress.substring(0, colonIndex);
                            port = originalAddress.substring(colonIndex + 1, hashIndex);
                            addressid = originalAddress.substring(hashIndex + 1);
                        } else if (address.includes(':')) {
                            const parts = address.split(':');
                            address = parts[0];
                            port = parts[1];
                        } else if (address.includes('#')) {
                            const parts = address.split('#');
                            address = parts[0];
                            addressid = parts[1];
                        }

                        // 只有当 addressid 看起来像 "address:port" 格式时才进行分割
                        // 避免截断包含时间的标题（如 "05:05:07"）
                        if (addressid.includes(':') && /^\S+:\d+$/.test(addressid)) {
                            addressid = addressid.split(':')[0];
                        }

                    } else {
                        address = match[1];
                        port = match[2] || port;
                        addressid = match[3] || address;
                    }

                    //console.log(address, port, addressid);
                    let 节点备注 = EndPS;

                    // 随机从 uuid_json 中抽取
                    if (uuid_json.length > 0) {
                        const randomIndex = Math.floor(Math.random() * uuid_json.length);
                        const selected = uuid_json[randomIndex];
                        const uuid = selected.uuid;
                        const 伪装域名 = selected.host;
                        if (trojan) {
                            const 木马Link = 'tr' + 'oj' + `an://${uuid}@${address}:${port}?security=tls&sni=${伪装域名}&type=ws&host=${伪装域名}&path=${encodeURIComponent(最终路径) + (跳过证书验证 ? '&allowInsecure=1' : '')}&fragment=${encodeURIComponent('1,40-60,30-50,tlshello')}#${encodeURIComponent(addressid + 节点备注)}`
                            return 木马Link;
                        } else {
                            const 为烈士Link = 'vl' + 'es' + `s://${uuid}@${address}:${port}?security=tls&sni=${伪装域名}&type=ws&host=${伪装域名}&path=${encodeURIComponent(最终路径) + (跳过证书验证 ? '&allowInsecure=1' : '')}&fragment=${encodeURIComponent('1,40-60,30-50,tlshello')}&encryption=none#${encodeURIComponent(addressid + 节点备注)}`;
                            if (xhttp) {
                                const xhttpLink = 'vl' + 'es' + `s://${uuid}@${address}:${port}?security=tls&sni=${伪装域名}&type=xhttp&host=${伪装域名}&path=${encodeURIComponent(最终路径) + (跳过证书验证 ? '&allowInsecure=1' : '')}&mode=stream-one&fragment=${encodeURIComponent('1,40-60,30-50,tlshello')}&encryption=none#${encodeURIComponent(addressid + 节点备注 + '-XHTTP')}`;
                                return 为烈士Link + '\n' + xhttpLink;
                            } else return 为烈士Link;
                        }
                    }
                }).join('\n');

                const 返回订阅内容 = userAgent.includes(('Mozilla').toLowerCase()) ? responseBody : encodeBase64(responseBody);

                if (!userAgent.includes(('Mozilla').toLowerCase())) responseHeaders["Content-Disposition"] = `attachment; filename*=utf-8''${encodeURIComponent(FileName)}`;
                return new Response(返回订阅内容, { headers: responseHeaders });
            }
        } else if (url.pathname === '/uuid.json') {
            if (!url.searchParams.has('host')) {
                return new Response(JSON.stringify({ error: '请提供 host 参数' }), {
                    status: 400,
                    headers: { 'Content-Type': 'application/json' },
                });
            }

            try {
                const result = await getLocalData(url.searchParams.get('host'));
                return new Response(JSON.stringify(result, null, 2), {
                    headers: { 'Content-Type': 'application/json' },
                });
            } catch (error) {
                return new Response(JSON.stringify({ error: error.message }), {
                    status: 500,
                    headers: { 'Content-Type': 'application/json' },
                });
            }
        } else if (url.pathname === '/proxy_host.zip') {
            // 代理主机压缩包下载
            try {
                const zipResponse = await fetch('https://raw.githubusercontent.com/cmliu/CF-Workers-BPSUB/main/proxy_host/proxy_host.zip');
                if (!zipResponse.ok) {
                    throw new Error('下载失败');
                }

                const zipData = await zipResponse.arrayBuffer();
                return new Response(zipData, {
                    headers: {
                        'Content-Type': 'application/zip',
                        'Content-Disposition': 'attachment; filename="proxy_host.zip"',
                        'Cache-Control': 'public, max-age=3600'
                    }
                });
            } catch (error) {
                return new Response('下载失败: ' + error.message, {
                    status: 500,
                    headers: { 'Content-Type': 'text/plain; charset=utf-8' }
                });
            }
        } else if (url.pathname === '/subapi.json') {
            return new Response(JSON.stringify(subapiList, null, 2), {
                headers: {
                    'Content-Type': 'application/json; charset=utf-8',
                    'Cache-Control': 'public, max-age=86400', // 1天缓存 (1*24*3600)
                    'Access-Control-Allow-Origin': '*',
                    'Access-Control-Allow-Methods': 'GET',
                    'Access-Control-Allow-Headers': 'Content-Type'
                }
            });
        } else if (url.pathname === '/subconfig.json') {
            const subConfigList = [{
                label: 'BPSUB',
                options: [{
                    label: `${FileName} 默认内置规则`,
                    value: subConfig
                }]
            }, {
                label: 'ACL4SSR',
                options: [{
                    label: 'ACL4SSR_Online 默认版 分组比较全',
                    value: 'https://raw.githubusercontent.com/ACL4SSR/ACL4SSR/master/Clash/config/ACL4SSR_Online.ini'
                }, {
                    label: 'ACL4SSR_Online_AdblockPlus 更多去广告',
                    value: 'https://raw.githubusercontent.com/ACL4SSR/ACL4SSR/master/Clash/config/ACL4SSR_Online_AdblockPlus.ini'
                }, {
                    label: 'ACL4SSR_Online_MultiCountry 多国分组',
                    value: 'https://raw.githubusercontent.com/ACL4SSR/ACL4SSR/master/Clash/config/ACL4SSR_Online_MultiCountry.ini'
                }, {
                    label: 'ACL4SSR_Online_NoAuto 无自动测速',
                    value: 'https://raw.githubusercontent.com/ACL4SSR/ACL4SSR/master/Clash/config/ACL4SSR_Online_NoAuto.ini'
                }, {
                    label: 'ACL4SSR_Online_NoReject 无广告拦截规则',
                    value: 'https://raw.githubusercontent.com/ACL4SSR/ACL4SSR/master/Clash/config/ACL4SSR_Online_NoReject.ini'
                }, {
                    label: 'ACL4SSR_Online_Mini 精简版',
                    value: 'https://raw.githubusercontent.com/ACL4SSR/ACL4SSR/master/Clash/config/ACL4SSR_Online_Mini.ini'
                }, {
                    label: 'ACL4SSR_Online_Mini_AdblockPlus.ini 精简版 更多去广告',
                    value: 'https://raw.githubusercontent.com/ACL4SSR/ACL4SSR/master/Clash/config/ACL4SSR_Online_Mini_AdblockPlus.ini'
                }, {
                    label: 'ACL4SSR_Online_Mini_NoAuto.ini 精简版 不带自动测速',
                    value: 'https://raw.githubusercontent.com/ACL4SSR/ACL4SSR/master/Clash/config/ACL4SSR_Online_Mini_NoAuto.ini'
                }, {
                    label: 'ACL4SSR_Online_Mini_Fallback.ini 精简版 带故障转移',
                    value: 'https://raw.githubusercontent.com/ACL4SSR/ACL4SSR/master/Clash/config/ACL4SSR_Online_Mini_Fallback.ini'
                }, {
                    label: 'ACL4SSR_Online_Mini_MultiMode.ini 精简版 自动测速、故障转移、负载均衡',
                    value: 'https://raw.githubusercontent.com/ACL4SSR/ACL4SSR/master/Clash/config/ACL4SSR_Online_Mini_MultiMode.ini'
                }, {
                    label: 'ACL4SSR_Online_Mini_MultiCountry.ini 精简版 带港美日国家',
                    value: 'https://raw.githubusercontent.com/ACL4SSR/ACL4SSR/master/Clash/config/ACL4SSR_Online_Mini_MultiCountry.ini'
                }, {
                    label: 'ACL4SSR_Online_Full 全分组 重度用户使用',
                    value: 'https://raw.githubusercontent.com/ACL4SSR/ACL4SSR/master/Clash/config/ACL4SSR_Online_Full.ini'
                }, {
                    label: 'ACL4SSR_Online_Full_MultiMode.ini 全分组 多模式 重度用户使用',
                    value: 'https://raw.githubusercontent.com/ACL4SSR/ACL4SSR/master/Clash/config/ACL4SSR_Online_Full_MultiMode.ini'
                }, {
                    label: 'ACL4SSR_Online_Full_NoAuto.ini 全分组 无自动测速 重度用户使用',
                    value: 'https://raw.githubusercontent.com/ACL4SSR/ACL4SSR/master/Clash/config/ACL4SSR_Online_Full_NoAuto.ini'
                }, {
                    label: 'ACL4SSR_Online_Full_AdblockPlus 全分组 重度用户使用 更多去广告',
                    value: 'https://raw.githubusercontent.com/ACL4SSR/ACL4SSR/master/Clash/config/ACL4SSR_Online_Full_AdblockPlus.ini'
                }, {
                    label: 'ACL4SSR_Online_Full_Netflix 全分组 重度用户使用 奈飞全量',
                    value: 'https://raw.githubusercontent.com/ACL4SSR/ACL4SSR/master/Clash/config/ACL4SSR_Online_Full_Netflix.ini'
                }, {
                    label: 'ACL4SSR_Online_Full_Google 全分组 重度用户使用 谷歌细分',
                    value: 'https://raw.githubusercontent.com/ACL4SSR/ACL4SSR/master/Clash/config/ACL4SSR_Online_Full_Google.ini'
                }]
            }, {
                label: 'CM规则',
                options: [{
                    label: 'CM_Online 默认版 识别港美地区',
                    value: 'https://raw.githubusercontent.com/cmliu/ACL4SSR/main/Clash/config/ACL4SSR_Online.ini'
                }, {
                    label: 'CM_Online_MultiCountry 识别港美地区 负载均衡',
                    value: 'https://raw.githubusercontent.com/cmliu/ACL4SSR/main/Clash/config/ACL4SSR_Online_MultiCountry.ini'
                }, {
                    label: 'CM_Online_MultiCountry_CF 识别港美地区、CloudFlareCDN 负载均衡 Worker节点专用',
                    value: 'https://raw.githubusercontent.com/cmliu/ACL4SSR/main/Clash/config/ACL4SSR_Online_MultiCountry_CF.ini'
                }, {
                    label: 'CM_Online_Full 识别多地区分组',
                    value: 'https://raw.githubusercontent.com/cmliu/ACL4SSR/main/Clash/config/ACL4SSR_Online_Full.ini'
                }, {
                    label: 'CM_Online_Full_CF 识别多地区、CloudFlareCDN 分组 Worker节点专用',
                    value: 'https://raw.githubusercontent.com/cmliu/ACL4SSR/main/Clash/config/ACL4SSR_Online_Full_CF.ini'
                }, {
                    label: 'CM_Online_Full_MultiMode 识别多地区 负载均衡',
                    value: 'https://raw.githubusercontent.com/cmliu/ACL4SSR/main/Clash/config/ACL4SSR_Online_Full_MultiMode.ini'
                }, {
                    label: 'CM_Online_Full_MultiMode_CF 识别多地区、CloudFlareCDN 负载均衡 Worker节点专用',
                    value: 'https://raw.githubusercontent.com/cmliu/ACL4SSR/main/Clash/config/ACL4SSR_Online_Full_MultiMode_CF.ini'
                }]
            }, {
                label: 'universal',
                options: [{
                    label: 'No-Urltest',
                    value: 'https://cdn.jsdelivr.net/gh/SleepyHeeead/subconverter-config@master/remote-config/universal/no-urltest.ini'
                }, {
                    label: 'Urltest',
                    value: 'https://cdn.jsdelivr.net/gh/SleepyHeeead/subconverter-config@master/remote-config/universal/urltest.ini'
                }]
            }, {
                label: 'customized',
                options: [{
                    label: 'Nirvana',
                    value: 'https://raw.githubusercontent.com/Mazetsz/ACL4SSR/master/Clash/config/V2rayPro.ini'
                }, {
                    label: 'V2Pro',
                    value: 'https://raw.githubusercontent.com/Mazeorz/airports/master/Clash/V2Pro.ini'
                }, {
                    label: '史迪仔-自动测速',
                    value: 'https://raw.githubusercontent.com/Mazeorz/airports/master/Clash/Stitch.ini'
                }, {
                    label: '史迪仔-负载均衡',
                    value: 'https://raw.githubusercontent.com/Mazeorz/airports/master/Clash/Stitch-Balance.ini'
                }, {
                    label: 'Maying',
                    value: 'https://cdn.jsdelivr.net/gh/SleepyHeeead/subconverter-config@master/remote-config/customized/maying.ini'
                }, {
                    label: 'Ytoo',
                    value: 'https://cdn.jsdelivr.net/gh/SleepyHeeead/subconverter-config@master/remote-config/customized/ytoo.ini'
                }, {
                    label: 'FlowerCloud',
                    value: 'https://cdn.jsdelivr.net/gh/SleepyHeeead/subconverter-config@master/remote-config/customized/flowercloud.ini'
                }, {
                    label: 'NyanCAT',
                    value: 'https://cdn.jsdelivr.net/gh/SleepyHeeead/subconverter-config@master/remote-config/customized/nyancat.ini'
                }, {
                    label: 'Nexitally',
                    value: 'https://cdn.jsdelivr.net/gh/SleepyHeeead/subconverter-config@master/remote-config/customized/nexitally.ini'
                }, {
                    label: 'SoCloud',
                    value: 'https://cdn.jsdelivr.net/gh/SleepyHeeead/subconverter-config@master/remote-config/customized/socloud.ini'
                }, {
                    label: 'ARK',
                    value: 'https://cdn.jsdelivr.net/gh/SleepyHeeead/subconverter-config@master/remote-config/customized/ark.ini'
                }, {
                    label: 'ssrCloud',
                    value: 'https://cdn.jsdelivr.net/gh/SleepyHeeead/subconverter-config@master/remote-config/customized/ssrcloud.ini'
                }]
            }, {
                label: 'Special',
                options: [{
                    label: 'NeteaseUnblock(仅规则，No-Urltest)',
                    value: 'https://cdn.jsdelivr.net/gh/SleepyHeeead/subconverter-config@master/remote-config/special/netease.ini'
                }, {
                    label: 'Basic(仅GEOIP CN + Final)',
                    value: 'https://cdn.jsdelivr.net/gh/SleepyHeeead/subconverter-config@master/remote-config/special/basic.ini'
                }]
            }];

            return new Response(JSON.stringify(subConfigList, null, 2), {
                headers: {
                    'Content-Type': 'application/json; charset=utf-8',
                    'Cache-Control': 'public, max-age=86400', // 1天缓存 (1*24*3600)
                    'Access-Control-Allow-Origin': '*',
                    'Access-Control-Allow-Methods': 'GET',
                    'Access-Control-Allow-Headers': 'Content-Type'
                }
            });
        } else if (url.pathname === '/check-version') {
            // 检查订阅转换后端版本
            const targetUrl = url.searchParams.get('url');
            if (!targetUrl) {
                return new Response(JSON.stringify({ success: false, error: 'Missing URL parameter' }), {
                    status: 400,
                    headers: { 'Content-Type': 'application/json' }
                });
            }

            // 安全验证：检查目标URL是否在允许的订阅转换后端列表中
            const allowedUrls = subapiList.map(item => item.value);
            if (!allowedUrls.includes(targetUrl)) {
                return new Response(JSON.stringify({
                    success: false,
                    error: 'Unauthorized URL - Only predefined subscription backends are allowed'
                }), {
                    status: 403,
                    headers: { 'Content-Type': 'application/json' }
                });
            }

            try {
                const versionUrl = targetUrl == 'default' ? `${subProtocol}://${subConverter.toLowerCase()}/version` : targetUrl + '/version';
                const response = await fetch(versionUrl, {
                    method: 'GET',
                    headers: {
                        'Accept': 'text/plain',
                        'User-Agent': 'Mozilla/5.0 (compatible; CF-Workers-BPSUB/1.0)'
                    }
                });

                if (response.ok) {
                    const versionText = await response.text();
                    return new Response(JSON.stringify({
                        success: true,
                        version: versionText.trim()
                    }), {
                        headers: { 'Content-Type': 'application/json' }
                    });
                } else {
                    return new Response(JSON.stringify({
                        success: false,
                        error: 'HTTP ' + response.status
                    }), {
                        headers: { 'Content-Type': 'application/json' }
                    });
                }
            } catch (error) {
                return new Response(JSON.stringify({
                    success: false,
                    error: error.message
                }), {
                    headers: { 'Content-Type': 'application/json' }
                });
            }
        } else {
            return await subHtml(request, hosts.length, FileName, subProtocol, subConverter, subConfig);
        }
    }
};

async function getSubData(host) {
    function parseVless(vlessUrl) {
        try {
            const url = vlessUrl.substring(8);
            const [uuid, rest] = url.split('@');
            if (!uuid || !rest) return null;
            const queryStart = rest.indexOf('?');
            if (queryStart === -1) return null;
            const queryString = rest.substring(queryStart + 1).split('#')[0];
            const params = new URLSearchParams(queryString);
            const host = params.get('host');
            //const path = `/snippets/ip=${encodeURIComponent(proxyIP)}`;
            if (!host) return null;
            return { uuid, host };
        } catch (error) {
            return null;
        }
    }
    const response = await fetch('https://cfxr.eu.org/getSub?host=' + host);
    if (!response.ok) {
        throw new Error(`HTTP error! status: ${response.status}`);
    }
    const text = await response.text();
    const lines = text.trim().split('\n');
    const result = [];

    for (const line of lines) {
        if (line.startsWith('vl' + 'es' + 's://')) {
            const parsed = parseVless(line);
            if (parsed) {
                result.push(parsed);
            }
        }
    }

    return result;
}

async function getLocalData(host, uuid = null) {
    function generateUUIDv4() {
        return 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, function (c) {
            const r = Math.random() * 16 | 0;
            const v = c == 'x' ? r : (r & 0x3 | 0x8);
            return v.toString(16);
        });
    }

    const finalUUID = (uuid && uuid.trim() !== '') ? uuid.trim() : generateUUIDv4();
    return [
        {
            "uuid": finalUUID,
            "host": host
        }
    ];
}

async function 整理成数组(内容) {
    // 将制表符、双引号、单引号和换行符都替换为逗号
    // 然后将连续的多个逗号替换为单个逗号
    var 替换后的内容 = 内容.replace(/[	|"'\r\n]+/g, ',').replace(/,+/g, ',');

    // 删除开头和结尾的逗号（如果有的话）
    if (替换后的内容.charAt(0) == ',') 替换后的内容 = 替换后的内容.slice(1);
    if (替换后的内容.charAt(替换后的内容.length - 1) == ',') 替换后的内容 = 替换后的内容.slice(0, 替换后的内容.length - 1);

    // 使用逗号分割字符串，得到地址数组
    const 地址数组 = 替换后的内容.split(',');

    return 地址数组;
}

async function 整理优选列表(api, FileName) {
    if (!api || api.length === 0) return [];

    let newapi = "";

    // 创建一个AbortController对象，用于控制fetch请求的取消
    const controller = new AbortController();

    const timeout = setTimeout(() => {
        controller.abort(); // 取消所有请求
    }, 2000); // 2秒后触发

    try {
        // 使用Promise.allSettled等待所有API请求完成，无论成功或失败
        // 对api数组进行遍历，对每个API地址发起fetch请求
        const responses = await Promise.allSettled(api.map(apiUrl => fetch(apiUrl, {
            method: 'get',
            headers: {
                'Accept': 'text/html,application/xhtml+xml,application/xml;',
                'User-Agent': FileName + ' (https://github.com/cmliu/CF-Workers-BPSUB)'
            },
            signal: controller.signal // 将AbortController的信号量添加到fetch请求中，以便于需要时可以取消请求
        }).then(response => response.ok ? response.text() : Promise.reject())));

        // 遍历所有响应
        for (const [index, response] of responses.entries()) {
            // 检查响应状态是否为'fulfilled'，即请求成功完成
            if (response.status === 'fulfilled') {
                // 获取响应的内容
                const content = await response.value;

                const lines = content.split(/\r?\n/);
                let 节点备注 = '';
                let 测速端口 = '443';

                if (lines[0].split(',').length > 3) {
                    const idMatch = api[index].match(/id=([^&]*)/);
                    if (idMatch) 节点备注 = idMatch[1];

                    const portMatch = api[index].match(/port=([^&]*)/);
                    if (portMatch) 测速端口 = portMatch[1];

                    for (let i = 1; i < lines.length; i++) {
                        const columns = lines[i].split(',')[0];
                        if (columns) {
                            newapi += `${columns}:${测速端口}${节点备注 ? `#${节点备注}` : ''}\n`;
                        }
                    }
                } else {
                    // 将内容添加到newapi中
                    newapi += content + '\n';
                }
            }
        }
    } catch (error) {
        console.error(error);
    } finally {
        // 无论成功或失败，最后都清除设置的超时定时器
        clearTimeout(timeout);
    }

    const newAddressesapi = await 整理成数组(newapi);

    // 返回处理后的结果
    return newAddressesapi;
}

function getDateString() {
    // 获取当前 UTC 时间
    const now = new Date();
    // 转换为 UTC+8
    const utc8Time = new Date(now.getTime() + (8 * 60 * 60 * 1000));
    // 加 24 小时
    utc8Time.setTime(utc8Time.getTime() + (24 * 60 * 60 * 1000 * 30));// 30天有效期
    // 格式化为 YYYY/MM/DD HH:MM:SS
    const year = utc8Time.getUTCFullYear();
    const month = String(utc8Time.getUTCMonth() + 1).padStart(2, '0');
    const day = String(utc8Time.getUTCDate()).padStart(2, '0');
    const hours = String(utc8Time.getUTCHours()).padStart(2, '0');
    const minutes = String(utc8Time.getUTCMinutes()).padStart(2, '0');
    const seconds = String(utc8Time.getUTCSeconds()).padStart(2, '0');
    return `${year}/${month}/${day} ${hours}:${minutes}:${seconds}`;
}

async function subHtml(request, hostLength = 0, FileName, subProtocol, subConverter, subConfig) {
    const HTML = `
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${FileName} Snippets订阅生成器</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&family=JetBrains+Mono:wght@400;500;600&display=swap" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/@keeex/qrcodejs-kx@1.0.2/qrcode.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/js-sha256@0.11.1/src/sha256.min.js"></script>
    <style>
        :root {
            --primary-color: #00ffff;
            --text-primary: #ffffff;
            --text-secondary: #e2e8f0;
            --bg-secondary: rgba(45, 55, 72, 0.8);
            --border-radius-sm: 12px;
            --warning-color: #ffc107;
        }
        
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
            background: linear-gradient(135deg, #0f0f23 0%, #1a1a2e 30%, #16213e  70%, #0f3460 100%);
            min-height: 100vh;
            padding: 20px;
            position: relative;
            overflow-x: hidden;
        }
        
        body::before {
            content: '';
            position: fixed;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: 
                radial-gradient(circle at 20% 80%, rgba(0, 255, 255, 0.1) 0%, transparent 50%),
                radial-gradient(circle at 80% 20%, rgba(0, 255, 157, 0.08) 0%, transparent 50%),
                radial-gradient(circle at 40% 40%, rgba(138, 43, 226, 0.1) 0%, transparent 50%);
            pointer-events: none;
        }
        
        .container {
            max-width: 900px;
            margin: 0 auto;
            background: rgba(26, 32, 44, 0.95);
            backdrop-filter: blur(20px);
            border-radius: 20px;
            box-shadow: 
                0 25px 50px rgba(0,0,0,0.3),
                0 0 0 1px rgba(0, 255, 255, 0.1),
                inset 0 1px 0 rgba(255, 255, 255, 0.1);
            overflow: hidden;
            border: 1px solid rgba(0, 255, 255, 0.2);
            position: relative;
        }
        
        .header {
            background: linear-gradient(135deg, #1a202c 0%, #2d3748 50%, #4a5568 100%);
            color: #00ffff;
            text-align: center;
            padding: 40px 30px;
            position: relative;
            overflow: hidden;
            border-bottom: 2px solid rgba(0, 255, 255, 0.3);
        }
        
        .social-links-container {
            position: absolute;
            top: 25px;
            right: 30px;
            display: flex;
            gap: 12px;
            z-index: 10;
        }
        
        .social-link {
            color: #00ffff;
            text-decoration: none;
            display: flex;
            align-items: center;
            justify-content: center;
            width: 40px;
            height: 40px;
            border: 2px solid rgba(0, 255, 255, 0.3);
            border-radius: 10px;
            transition: all 0.3s ease;
            background: rgba(26, 32, 44, 0.8);
            backdrop-filter: blur(10px);
        }
        
        .social-link:hover {
            color: #ffffff;
            border-color: #00ffff;
            background: rgba(0, 255, 255, 0.1);
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(0, 255, 255, 0.3);
        }
        
        .social-link svg {
            width: 20px;
            height: 20px;
            transition: transform 0.3s ease;
        }
        
        .social-link:hover svg {
            transform: scale(1.1);
        }
        
        .header::before {
            content: '';
            position: absolute;
            top: -50%;
            left: -50%;
            width: 200%;
            height: 200%;
            background: repeating-conic-gradient(
                from 0deg,
                transparent 0deg 90deg,
                rgba(0, 255, 255, 0.1) 90deg 180deg
            );
            animation: rotate 20s linear infinite;
        }
        
        @keyframes rotate {
            from { transform: rotate(0deg); }
            to { transform: rotate(360deg); }
        }
        
        .header h1 {
            font-size: 3em;
            margin-bottom: 15px;
            font-weight: 800;
            text-shadow: 0 0 30px rgba(255, 255, 255, 0.8), 0 2px 4px rgba(0,0,0,0.3);
            position: relative;
            z-index: 1;
            color: #ffffff;
        }
        
        .header p {
            font-size: 1.2em;
            opacity: 0.95;
            position: relative;
            z-index: 1;
            color: #f7fafc;
        }
        
        .form-container {
            padding: 40px;
        }
        
        .section {
            margin-bottom: 35px;
            background: rgba(45, 55, 72, 0.8);
            border-radius: 15px;
            padding: 25px;
            border: 1px solid rgba(0, 255, 255, 0.2);
            transition: all 0.3s ease;
            position: relative;
            z-index: 1;
        }
        
        .section::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: linear-gradient(135deg, rgba(0, 255, 255, 0.05) 0%, rgba(138, 43, 226, 0.05) 100%);
            border-radius: 15px;
            opacity: 0;
            transition: opacity 0.3s ease;
            pointer-events: none;
        }
        
        .section:hover::before {
            opacity: 1;
        }
        
        .section:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 30px rgba(0, 255, 255, 0.2);
            border-color: rgba(0, 255, 255, 0.4);
        }
        
        .section-title {
            font-size: 1.4em;
            color: #00ffff;
            margin-bottom: 20px;
            padding-bottom: 12px;
            border-bottom: 2px solid rgba(0, 255, 255, 0.3);
            font-weight: 700;
            display: flex;
            align-items: center;
            gap: 10px;
            cursor: pointer;
            user-select: none;
            position: relative;
            z-index: 1;
        }
        
        .collapsible .section-title::after {
            content: '▼';
            font-size: 0.8em;
            transition: transform 0.3s ease;
            margin-left: auto;
        }
        
        .collapsible.collapsed .section-title::after {
            transform: rotate(-90deg);
        }
        
        .section-content {
            transition: all 0.3s ease;
            overflow: visible;
        }
        
        .collapsible.collapsed .section-content {
            max-height: 0;
            opacity: 0;
            overflow: hidden;
            padding-top: 0;
            margin-top: 0;
        }
        
        .form-group {
            margin-bottom: 25px;
        }
        
        label {
            display: block;
            margin-bottom: 10px;
            font-weight: 600;
            color: #e2e8f0;
            font-size: 1em;
            min-height: 24px;
            display: flex;
            align-items: center;
        }
        
        textarea, input[type="text"], select {
            width: 100%;
            padding: 15px 18px;
            border: 2px solid rgba(0, 255, 255, 0.2);
            border-radius: 12px;
            font-size: 15px;
            transition: all 0.3s ease;
            font-family: 'JetBrains Mono', 'Courier New', monospace;
            background: rgba(26, 32, 44, 0.9);
            color: #e2e8f0;
            position: relative;
            z-index: 10;
        }
        
        textarea:focus, input[type="text"]:focus, select:focus {
            outline: none;
            border-color: #00ffff;
            box-shadow: 0 0 0 4px rgba(0, 255, 255, 0.2), 0 0 20px rgba(0, 255, 255, 0.1);
            transform: translateY(-1px);
        }
        
        textarea::placeholder, input[type="text"]::placeholder {
            color: #718096;
        }
        
        select {
            cursor: pointer;
            font-weight: 500;
            appearance: none;
            -webkit-appearance: none;
            -moz-appearance: none;
            background-image: url('data:image/svg+xml;utf8,<svg xmlns="http://www.w3.org/2000/svg" width="12" height="8" viewBox="0 0 12 8"><path fill="%2300ffff" d="M6 8L0 2h12L6 8z"/></svg>');
            background-repeat: no-repeat;
            background-position: right 15px center;
            padding-right: 45px;
        }
        
        select:hover {
            border-color: rgba(0, 255, 255, 0.4);
            background-color: rgba(0, 255, 255, 0.05);
        }
        
        select option {
            background: rgba(26, 32, 44, 0.95);
            color: #e2e8f0;
            padding: 12px 15px;
            border: none;
            font-weight: 500;
        }
        
        select option:hover, select option:checked {
            background: rgba(0, 255, 255, 0.1);
        }
        
        textarea {
            height: 380px;
            resize: vertical;
            line-height: 1.5;
        }
        
        .example {
            background: linear-gradient(135deg, rgba(45, 55, 72, 0.8) 0%, rgba(26, 32, 44, 0.8) 100%);
            border: 1px solid rgba(0, 255, 255, 0.2);
            border-radius: 10px;
            padding: 18px;
            margin-top: 12px;
            font-size: 13px;
            color: #a0aec0;
            white-space: pre-line;
            font-family: 'JetBrains Mono', 'Courier New', monospace;
            border-left: 4px solid #00ffff;
        }
        
        .generate-btn {
            width: 100%;
            padding: 18px;
            border-radius: 12px;
            font-size: 1.2em;
            font-weight: 700;
            cursor: pointer;
            transition: all 0.3s ease;
            position: relative;
            overflow: hidden;
            color: #ffffff;
        }
        
        /* 主按钮 - 生成订阅 (青色主题) */
        .generate-btn:not(.short-url-btn) {
            background: linear-gradient(135deg, rgba(0, 255, 255, 0.25) 0%, rgba(138, 43, 226, 0.25) 100%);
            border: 2px solid rgba(0, 255, 255, 0.6);
            box-shadow: 0 4px 15px rgba(0, 255, 255, 0.4);
        }
        
        .generate-btn::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(90deg, transparent, rgba(255,255,255,0.3), transparent);
            transition: left 0.5s;
        }
        
        /* 主按钮hover效果 */
        .generate-btn:not(.short-url-btn):hover {
            transform: translateY(-2px);
            background: linear-gradient(135deg, rgba(0, 255, 255, 0.35) 0%, rgba(138, 43, 226, 0.35) 100%);
            border-color: rgba(0, 255, 255, 0.9);
            box-shadow: 0 8px 25px rgba(0, 255, 255, 0.6);
        }
        
        .generate-btn:hover::before {
            left: 100%;
        }
        
        .generate-btn:active {
            transform: translateY(0);
        }
        
        .button-container {
            display: flex;
            gap: 15px;
            width: 100%;
        }
        
        .button-container .generate-btn {
            flex: 1;
        }
        
        .short-url-btn:disabled {
            background: linear-gradient(135deg, rgba(128, 128, 128, 0.3) 0%, rgba(64, 64, 64, 0.3) 100%);
            color: #999999;
            border-color: rgba(128, 128, 128, 0.3);
            cursor: not-allowed;
            box-shadow: none;
            transform: none !important;
        }
        
        .short-url-btn:disabled::before {
            display: none;
        }
        
        .short-url-btn:disabled:hover {
            background: linear-gradient(135deg, rgba(128, 128, 128, 0.3) 0%, rgba(64, 64, 64, 0.3) 100%);
            border-color: rgba(128, 128, 128, 0.3);
            box-shadow: none;
            transform: none;
        }
        
        /* 副按钮 - 生成短链 (橙色主题) */
        .short-url-btn:not(:disabled) {
            background: linear-gradient(135deg, rgba(251, 146, 60, 0.2) 0%, rgba(245, 101, 101, 0.2) 100%);
            border: 2px solid rgba(251, 146, 60, 0.5);
            color: #ffffff;
            box-shadow: 0 3px 12px rgba(251, 146, 60, 0.3);
        }
        
        .short-url-btn:not(:disabled):hover {
            background: linear-gradient(135deg, rgba(251, 146, 60, 0.3) 0%, rgba(245, 101, 101, 0.3) 100%);
            border-color: rgba(251, 146, 60, 0.7);
            box-shadow: 0 6px 20px rgba(251, 146, 60, 0.4);
            transform: translateY(-1px);
        }
        
        .short-url-btn:not(:disabled)::before {
            background: linear-gradient(90deg, transparent, rgba(255,255,255,0.2), transparent);
        }
        
        /* 右上角气泡通知样式 */
        #notification-container {
            position: fixed;
            top: 20px;
            right: 20px;
            z-index: 9999;
            max-width: 400px;
            pointer-events: none;
        }
        
        .notification {
            background: rgba(26, 32, 44, 0.95);
            backdrop-filter: blur(20px);
            border-radius: 12px;
            padding: 16px 20px;
            margin-bottom: 12px;
            border: 1px solid rgba(0, 255, 255, 0.3);
            box-shadow: 
                0 10px 30px rgba(0, 0, 0, 0.5),
                0 0 0 1px rgba(0, 255, 255, 0.1);
            font-size: 14px;
            font-weight: 500;
            display: flex;
            align-items: center;
            gap: 12px;
            opacity: 0;
            transform: translateX(100%) translateY(-10px);
            transition: all 0.4s cubic-bezier(0.175, 0.885, 0.32, 1.275);
            pointer-events: auto;
            position: relative;
            overflow: hidden;
        }
        
        .notification::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: linear-gradient(135deg, rgba(0, 255, 255, 0.1) 0%, rgba(138, 43, 226, 0.1) 100%);
            opacity: 0;
            transition: opacity 0.3s ease;
        }
        
        .notification:hover::before {
            opacity: 1;
        }
        
        .notification.show {
            opacity: 1;
            transform: translateX(0) translateY(0);
        }
        
        .notification.success {
            border-color: rgba(0, 255, 157, 0.5);
            color: #00ff9d;
        }
        
        .notification.success::after {
            content: '';
            position: absolute;
            left: 0;
            top: 0;
            bottom: 0;
            width: 4px;
            background: linear-gradient(180deg, #00ff9d 0%, rgba(0, 255, 157, 0.3) 100%);
            border-radius: 0 12px 12px 0;
        }
        
        .notification.error {
            border-color: rgba(255, 193, 7, 0.5);
            color: #ffc107;
        }
        
        .notification.error::after {
            content: '';
            position: absolute;
            left: 0;
            top: 0;
            bottom: 0;
            width: 4px;
            background: linear-gradient(180deg, #ffc107 0%, rgba(255, 193, 7, 0.3) 100%);
            border-radius: 0 12px 12px 0;
        }
        
        .notification-content {
            position: relative;
            z-index: 1;
            flex: 1;
        }
        
        .notification-close {
            position: relative;
            z-index: 1;
            background: none;
            border: none;
            color: rgba(255, 255, 255, 0.6);
            font-size: 18px;
            cursor: pointer;
            padding: 0;
            width: 24px;
            height: 24px;
            display: flex;
            align-items: center;
            justify-content: center;
            border-radius: 50%;
            transition: all 0.2s ease;
        }
        
        .notification-close:hover {
            background: rgba(255, 255, 255, 0.1);
            color: #ffffff;
        }
        
        .result-section {
            margin-top: 35px;
            display: none;
            animation: fadeInUp 0.5s ease-out;
        }
        

        
        .copied {
            animation: pulse 0.6s ease-in-out;
        }
        
        @keyframes pulse {
            0% { transform: scale(1); }
            50% { transform: scale(1.05); }
            100% { transform: scale(1); }
        }
        
        @keyframes fadeInUp {
            from {
                opacity: 0;
                transform: translateY(30px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }
        
        .result-url {
            background: linear-gradient(135deg, rgba(45, 55, 72, 0.8) 0%, rgba(26, 32, 44, 0.8) 100%);
            border: 2px solid rgba(0, 255, 255, 0.2);
            border-radius: 12px;
            padding: 18px;
            word-break: break-all;
            font-family: 'JetBrains Mono', 'Courier New', monospace;
            font-size: 15px;
            cursor: pointer;
            transition: all 0.3s ease;
            position: relative;
            overflow: hidden;
            color: #e2e8f0;
        }
        
        .result-url::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: linear-gradient(135deg, rgba(0, 255, 255, 0.1) 0%, rgba(138, 43, 226, 0.1) 100%);
            opacity: 0;
            transition: opacity 0.3s ease;
        }
        
        .result-url:hover {
            border-color: #00ffff;
            transform: translateY(-1px);
            box-shadow: 0 5px 15px rgba(0, 255, 255, 0.3);
        }
        
        .result-url:hover::before {
            opacity: 1;
        }
        
        .copy-success {
            background: linear-gradient(135deg, rgba(0, 255, 157, 0.2) 0%, rgba(0, 255, 255, 0.2) 100%) !important;
            border-color: #00ff9d !important;
            color: #00ff9d;
            animation: successPulse 0.6s ease;
        }
        
        @keyframes successPulse {
            0% { transform: scale(1); }
            50% { transform: scale(1.02); }
            100% { transform: scale(1); }
        }
        
        .qr-container {
            margin-top: 25px;
            text-align: center;
            padding: 20px;
            background: linear-gradient(135deg, rgba(45, 55, 72, 0.8) 0%, rgba(26, 32, 44, 0.8) 100%);
            border: 2px solid rgba(0, 255, 255, 0.2);
            border-radius: 12px;
            display: none;
        }
        
        .qr-title {
            color: #00ffff;
            font-size: 1.1em;
            font-weight: 600;
            margin-bottom: 15px;
        }
        
        .qr-code {
            display: inline-block;
            padding: 15px;
            background: white;
            border-radius: 10px;
            box-shadow: 0 4px 15px rgba(0, 255, 255, 0.2);
        }
        
        .qr-description {
            color: #a0aec0;
            font-size: 0.9em;
            margin-top: 15px;
        }
        
        .footer {
            text-align: center;
            padding: 25px;
            color: #718096;
            border-top: 1px solid rgba(0, 255, 255, 0.2);
            background: rgba(26, 32, 44, 0.5);
            font-weight: 500;
        }
        
        .footer p {
            margin: 8px 0;
        }
        
        .footer .thanks-link {
            color: #00ffff;
            text-decoration: none;
            border-bottom: 1px solid transparent;
            transition: all 0.3s ease;
            display: inline-flex;
            align-items: center;
            gap: 5px;
        }
        
        .footer .thanks-link:hover {
            color: #ffffff;
            border-bottom-color: #00ffff;
            transform: translateY(-1px);
        }
        
        @media (max-width: 768px) {
            body {
                padding: 15px;
            }
            
            .form-container {
                padding: 25px 20px;
            }
            
            .header {
                padding: 30px 20px;
            }
            
            .header h1 {
                font-size: 2.2em;
            }
            
            .social-links-container {
                right: 20px;
                gap: 8px;
            }
            
            .social-link {
                width: 36px;
                height: 36px;
            }
            
            .social-link svg {
                width: 18px;
                height: 18px;
            }
            
            .section {
                padding: 20px;
                margin-bottom: 25px;
            }
            
            .section-title {
                font-size: 1.2em;
            }
        }
        
        @media (max-width: 480px) {
            .header h1 {
                font-size: 1.8em;
            }
            
            .social-links-container {
                right: 15px;
                top: 20px;
                gap: 6px;
            }
            
            .social-link {
                width: 32px;
                height: 32px;
            }
            
            .social-link svg {
                width: 16px;
                height: 16px;
            }
            
            .form-container {
                padding: 20px 15px;
            }
            
            .section {
                padding: 15px;
            }
        }
        
        /* ProxyIP 说明相关样式 */
        .code-block {
            padding: 16px 20px;
            border-radius: var(--border-radius-sm);
            margin: 16px 0;
            font-family: 'JetBrains Mono', 'Courier New', monospace;
            font-size: 14px;
            line-height: 1.6;
        }
        
        .proxy-flow-container {
            background: var(--bg-secondary);
            padding: 20px;
            border-radius: var(--border-radius-sm);
            margin: 20px 0;
        }
        
        .proxy-flow {
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-bottom: 16px;
            flex-wrap: wrap;
            gap: 16px;
        }
        
        .proxy-step {
            padding: 12px;
            border-radius: 8px;
            text-align: center;
            flex: 1;
            min-width: 120px;
        }
        
        .proxy-step-1 { background: #e3f2fd; }
        .proxy-step-2 { background: #f3e5f5; }
        .proxy-step-3 { background: #e8f5e8; }
        
        .proxy-step-title {
            font-weight: 600;
            margin-bottom: 4px;
        }
        
        .proxy-step-1 .proxy-step-title { color: #1976d2; }
        .proxy-step-2 .proxy-step-title { color: #7b1fa2; }
        .proxy-step-3 .proxy-step-title { color: #388e3c; }
        
        .proxy-step-desc {
            font-size: 0.9rem;
        }
        
        /* 修复每个步骤描述文字的颜色 */
        .proxy-step-1 .proxy-step-desc { color: #1565c0; }
        .proxy-step-2 .proxy-step-desc { color: #6a1b9a; }
        .proxy-step-3 .proxy-step-desc { color: #2e7d32; }
        
        .proxy-arrow {
            color: var(--primary-color);
            font-size: 1.5rem;
        }
        
        .proxy-explanation {
            text-align: center;
            color: var(--text-secondary);
            font-size: 0.95rem;
            margin: 0;
        }
        
        /* 修复链接点击问题 */
        .section-content a {
            position: relative;
            z-index: 100;
            pointer-events: auto;
            transition: all 0.3s ease;
        }
        
        .section-content a:hover {
            color: #ffffff !important;
            text-decoration: underline !important;
        }
        
        /* 代理模式选择器样式 */
        .proxy-mode-selector {
            display: flex;
            gap: 20px;
            margin-bottom: 20px;
            flex-wrap: wrap;
        }
        
        .radio-option {
            display: flex;
            align-items: center;
            cursor: pointer;
            padding: 12px 18px;
            border: 2px solid rgba(0, 255, 255, 0.2);
            border-radius: 10px;
            transition: all 0.3s ease;
            background: rgba(26, 32, 44, 0.5);
            position: relative;
            flex: 1;
            min-width: 180px;
        }
        
        .radio-option:hover {
            border-color: rgba(0, 255, 255, 0.4);
            background: rgba(0, 255, 255, 0.1);
        }
        
        .radio-option.disabled {
            opacity: 0.5;
            cursor: not-allowed;
            pointer-events: none;
        }
        
        .radio-option.disabled .radio-label {
            color: #666;
        }
        
        .radio-option input[type="radio"] {
            margin-right: 10px;
            width: 18px;
            height: 18px;
            accent-color: var(--primary-color);
        }
        
        .radio-option input[type="radio"]:checked + .radio-label {
            color: var(--primary-color);
            font-weight: 600;
        }
        
        .radio-option.checked {
            border-color: var(--primary-color);
            background: rgba(0, 255, 255, 0.15);
            box-shadow: 0 0 15px rgba(0, 255, 255, 0.3);
        }
        
        .radio-label {
            color: var(--text-secondary);
            font-weight: 500;
            transition: all 0.3s ease;
            flex: 1;
        }
        
        @media (max-width: 600px) {
            .proxy-mode-selector {
                flex-direction: column;
            }
            
            .radio-option {
                min-width: auto;
            }
        }
        
        /* 复选框样式 */
        .checkbox-option {
            display: flex;
            align-items: center;
            cursor: pointer;
            padding: 8px 12px;
            border: 2px solid rgba(0, 255, 255, 0.2);
            border-radius: 8px;
            transition: all 0.3s ease;
            background: rgba(26, 32, 44, 0.3);
        }
        
        .checkbox-option:hover {
            border-color: rgba(0, 255, 255, 0.4);
            background: rgba(0, 255, 255, 0.1);
        }
        
        .checkbox-option input[type="checkbox"] {
            margin-right: 10px;
            width: 16px;
            height: 16px;
            accent-color: var(--primary-color);
        }
        
        .checkbox-option input[type="checkbox"]:checked + .checkbox-label {
            color: var(--primary-color);
            font-weight: 600;
        }
        
        .checkbox-option.checked {
            border-color: var(--primary-color);
            background: rgba(0, 255, 255, 0.15);
        }
        
        .checkbox-label {
            color: var(--text-secondary);
            font-weight: 500;
            transition: all 0.3s ease;
        }
        
        /* 高级参数容器样式 */
        .advanced-params-container {
            display: flex;
            gap: 20px;
            flex-wrap: wrap;
        }
        
        .advanced-params-container .checkbox-option {
            flex: 1;
            min-width: 200px;
        }
        
        /* 响应式：移动端分行显示 */
        @media (max-width: 768px) {
            .advanced-params-container {
                flex-direction: column;
                gap: 15px;
            }
            
            .advanced-params-container .checkbox-option {
                flex: none;
                min-width: auto;
            }
        }
        
        /* Socks5 标题行样式 */
        .socks5-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 10px;
            flex-wrap: nowrap;
            gap: 10px;
            position: relative;
            z-index: 5;
            height: 24px;
            min-height: 24px;
            max-height: 24px;
            overflow: hidden;
        }
        
        /* 行内复选框样式 */
        .checkbox-option-inline {
            display: flex;
            align-items: center;
            cursor: pointer;
            padding: 0;
            border: none;
            border-radius: 0;
            transition: all 0.3s ease;
            background: transparent;
            font-size: 0.9em;
            position: relative;
            z-index: 10;
            height: 24px;
            min-height: 24px;
            max-height: 24px;
            align-self: center;
            line-height: 1;
        }
        
        .checkbox-option-inline:hover {
            border-color: transparent;
            background: transparent;
        }
        
        .checkbox-option-inline input[type="checkbox"] {
            margin-right: 8px;
            width: 14px;
            height: 14px;
            accent-color: var(--primary-color);
            cursor: pointer;
            pointer-events: auto;
            position: relative;
            z-index: 10;
            flex-shrink: 0;
        }
        
        .checkbox-option-inline input[type="checkbox"]:checked + .checkbox-label-inline {
            color: var(--primary-color);
            font-weight: 600;
        }
        
        .checkbox-option-inline.checked {
            border-color: transparent;
            background: transparent;
        }
        
        .checkbox-label-inline {
            color: var(--text-secondary);
            font-weight: 500;
            transition: all 0.3s ease;
            white-space: nowrap;
            cursor: pointer;
            user-select: none;
            position: relative;
            z-index: 10;
            line-height: 1;
            display: flex;
            align-items: center;
            height: 24px;
        }
        
        /* 选项卡样式 */
        .tabs-container {
            margin-top: 20px;
            border: 1px solid rgba(0, 255, 255, 0.3);
            border-radius: 12px;
            overflow: hidden;
        }
        
        .tabs-header {
            display: flex;
            background: rgba(26, 32, 44, 0.8);
            border-bottom: 1px solid rgba(0, 255, 255, 0.3);
        }
        
        .tab-button {
            flex: 1;
            padding: 15px 20px;
            background: transparent;
            border: none;
            color: #a0aec0;
            font-size: 14px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            position: relative;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
        }
        
        .tab-button:hover {
            color: #e2e8f0;
            background: rgba(0, 255, 255, 0.1);
        }
        
        .tab-button.active {
            color: #00ffff;
            background: rgba(0, 255, 255, 0.15);
        }
        
        .tab-button.active::after {
            content: '';
            position: absolute;
            bottom: 0;
            left: 0;
            right: 0;
            height: 3px;
            background: linear-gradient(90deg, #00ffff, #00ff9d);
        }
        
        .tab-button:not(:last-child) {
            border-right: 1px solid rgba(0, 255, 255, 0.2);
        }
        
        .tab-content {
            padding: 25px;
            background: rgba(45, 55, 72, 0.8);
            min-height: 200px;
        }
        
        .tab-panel {
            display: none;
            animation: fadeInUp 0.3s ease-out;
        }
        
        .tab-panel.active {
            display: block;
        }
        
        @keyframes fadeInUp {
            from {
                opacity: 0;
                transform: translateY(10px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }
        
        /* 代码框点击复制样式 */
        #workerCode:hover {
            border-color: rgba(0, 255, 255, 0.4) !important;
            box-shadow: 0 0 10px rgba(0, 255, 255, 0.2) !important;
        }
        
        #workerCode:active {
            background: rgba(26, 32, 44, 0.95) !important;
            transform: scale(0.999);
        }
        
        #snippetCode:hover {
            border-color: rgba(0, 255, 255, 0.4) !important;
            box-shadow: 0 0 10px rgba(0, 255, 255, 0.2) !important;
        }
        
        #snippetCode:active {
            background: rgba(26, 32, 44, 0.95) !important;
            transform: scale(0.999);
        }
        
        /* 选项卡响应式 */
        @media (max-width: 600px) {
            .tab-button {
                padding: 12px 15px;
                font-size: 13px;
            }
            
            .tab-content {
                padding: 20px 15px;
            }
        }
        
        /* 响应式处理 */
        @media (max-width: 500px) {
            .socks5-header {
                flex-direction: row;
                align-items: center;
                flex-wrap: wrap;
                height: auto;
                min-height: 24px;
                max-height: none;
            }
            
            .checkbox-option-inline {
                align-self: center;
                margin-top: 5px;
            }
        }
    </style>
</head>
<body>
    <!-- 右上角气泡通知容器 -->
    <div id="notification-container"></div>
    
    <div class="container">
        <div class="header">
            <div class="social-links-container">
                <a href="https://github.com/cmliu/CF-Workers-BPSUB" target="_blank" class="social-link" title="BPSUB GitHub 源码仓库">
                    <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 16 16">
                        <path fill="currentColor" fill-rule="evenodd" d="M7.976 0A7.977 7.977 0 0 0 0 7.976c0 3.522 2.3 6.507 5.431 7.584c.392.049.538-.196.538-.392v-1.37c-2.201.49-2.69-1.076-2.69-1.076c-.343-.93-.881-1.175-.881-1.175c-.734-.489.048-.489.048-.489c.783.049 1.224.832 1.224.832c.734 1.223 1.859.88 2.3.685c.048-.538.293-.88.489-1.076c-1.762-.196-3.621-.881-3.621-3.964c0-.88.293-1.566.832-2.153c-.05-.147-.343-.978.098-2.055c0 0 .685-.196 2.201.832c.636-.196 1.322-.245 2.007-.245s1.37.098 2.006.245c1.517-1.027 2.202-.832 2.202-.832c.44 1.077.146 1.908.097 2.104a3.16 3.16 0 0 1 .832 2.153c0 3.083-1.86 3.719-3.62 3.915c.293.244.538.733.538 1.467v2.202c0 .196.146.44.538.392A7.98 7.98 0 0 0 16 7.976C15.951 3.572 12.38 0 7.976 0" clip-rule="evenodd"></path>
                    </svg>
                </a>
                <a href="https://t.me/CMLiussss" target="_blank" class="social-link" title="CMLiussss 技术交流群">
                    <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 256 256">
                        <defs>
                            <linearGradient id="telegramGradient1" x1="50%" x2="50%" y1="0%" y2="100%">
                                <stop offset="0%" stop-color="#2AABEE"></stop>
                                <stop offset="100%" stop-color="#229ED9"></stop>
                            </linearGradient>
                        </defs>
                        <path fill="url(#telegramGradient1)" d="M128 0C94.06 0 61.48 13.494 37.5 37.49A128.04 128.04 0 0 0 0 128c0 33.934 13.5 66.514 37.5 90.51C61.48 242.506 94.06 256 128 256s66.52-13.494 90.5-37.49c24-23.996 37.5-56.576 37.5-90.51s-13.5-66.514-37.5-90.51C194.52 13.494 161.94 0 128 0"></path>
                        <path fill="#FFF" d="M57.94 126.648q55.98-24.384 74.64-32.152c35.56-14.786 42.94-17.354 47.76-17.441c1.06-.017 3.42.245 4.96 1.49c1.28 1.05 1.64 2.47 1.82 3.467c.16.996.38 3.266.2 5.038c-1.92 20.24-10.26 69.356-14.5 92.026c-1.78 9.592-5.32 12.808-8.74 13.122c-7.44.684-13.08-4.912-20.28-9.63c-11.26-7.386-17.62-11.982-28.56-19.188c-12.64-8.328-4.44-12.906 2.76-20.386c1.88-1.958 34.64-31.748 35.26-34.45c.08-.338.16-1.598-.6-2.262c-.74-.666-1.84-.438-2.64-.258c-1.14.256-19.12 12.152-54 35.686c-5.1 3.508-9.72 5.218-13.88 5.128c-4.56-.098-13.36-2.584-19.9-4.708c-8-2.606-14.38-3.984-13.82-8.41c.28-2.304 3.46-4.662 9.52-7.072"></path>
                    </svg>
                </a>
                <a href="https://t.me/bestip_one" target="_blank" class="social-link" title="白嫖哥交流群">
                    <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 256 256">
                        <defs>
                            <linearGradient id="telegramGradient2" x1="50%" x2="50%" y1="0%" y2="100%">
                                <stop offset="0%" stop-color="#2AABEE"></stop>
                                <stop offset="100%" stop-color="#229ED9"></stop>
                            </linearGradient>
                        </defs>
                        <path fill="url(#telegramGradient2)" d="M128 0C94.06 0 61.48 13.494 37.5 37.49A128.04 128.04 0 0 0 0 128c0 33.934 13.5 66.514 37.5 90.51C61.48 242.506 94.06 256 128 256s66.52-13.494 90.5-37.49c24-23.996 37.5-56.576 37.5-90.51s-13.5-66.514-37.5-90.51C194.52 13.494 161.94 0 128 0"></path>
                        <path fill="#FFF" d="M57.94 126.648q55.98-24.384 74.64-32.152c35.56-14.786 42.94-17.354 47.76-17.441c1.06-.017 3.42.245 4.96 1.49c1.28 1.05 1.64 2.47 1.82 3.467c.16.996.38 3.266.2 5.038c-1.92 20.24-10.26 69.356-14.5 92.026c-1.78 9.592-5.32 12.808-8.74 13.122c-7.44.684-13.08-4.912-20.28-9.63c-11.26-7.386-17.62-11.982-28.56-19.188c-12.64-8.328-4.44-12.906 2.76-20.386c1.88-1.958 34.64-31.748 35.26-34.45c.08-.338.16-1.598-.6-2.262c-.74-.666-1.84-.438-2.64-.258c-1.14.256-19.12 12.152-54 35.686c-5.1 3.508-9.72 5.218-13.88 5.128c-4.56-.098-13.36-2.584-19.9-4.708c-8-2.606-14.38-3.984-13.82-8.41c.28-2.304 3.46-4.662 9.52-7.072"></path>
                    </svg>
                </a>
            </div>
            <h1>🚀 ${FileName}</h1>
            <p>Cloudflare Snippets 订阅生成器</p>
        </div>
        
        <div class="form-container">
            <!-- 代理域名设置 -->
            <div class="section">
                <div class="section-title">🌐 代理域名设置(${(hostLength < 1) ? '必填' : '可选'})</div>
                <div class="form-group">
                    <label for="proxyHost">HOST：</label>
                    <input type="text" id="proxyHost" placeholder="proxy.pages.dev" value="">
                    <div style="background: rgba(255, 193, 7, 0.1); border-left: 4px solid #ff6161ff; padding: 10px; margin: 8px 0; border-radius: 6px; font-size: 13px;">
                        <span style="color: #ff4c4cff; font-weight: 600;">🚨 需要注意：</span>
                        <span style="color: #e2e8f0;">HOST域名直接决定节点的可用性，如果节点无法使用，请自行检查HOST域名是否被GFW屏蔽或阻断</span>
                    </div>
                    
                    <!-- 部署教程选项卡 -->
                    <div class="tabs-container">
                        <div class="tabs-header">
                            <button class="tab-button active" onclick="switchTab('snippets')" id="snippets-tab">
                                📃 CF Snippets 部署
                            </button>
                        </div>
                        <div class="tab-content">
                            <!-- Workers 选项卡内容 -->
                            <div class="tab-panel" id="workers-panel">
                                <p style="color: #e2e8f0; margin-bottom: 15px; line-height: 1.6;">
                                    1️⃣ 复制下方代码 → 2️⃣ 进入Cloudflare Workers → 3️⃣ 创建新Worker → 4️⃣ 粘贴代码并部署
                                </p>
                                <div style="position: relative;">
                                    <textarea readonly onclick="copyWorkerCode()" style="
                                        width: 100%; 
                                        height: 238px; 
                                        background: #1a202c; 
                                        border: 2px solid rgba(0, 255, 255, 0.2);
                                        border-radius: 8px; 
                                        padding: 15px; 
                                        font-family: 'JetBrains Mono', monospace; 
                                        font-size: 13px; 
                                        color: #e2e8f0; 
                                        resize: vertical;
                                        line-height: 1.4;
                                        cursor: pointer;
                                        transition: all 0.3s ease;
                                    " id="workerCode" title="点击复制代码">正在加载代码...</textarea>
                                    <button onclick="copyWorkerCode()" style="
                                        position: absolute;
                                        top: 10px;
                                        right: 10px;
                                        background: rgba(0, 255, 255, 0.2);
                                        color: #00ffff;
                                        border: 1px solid rgba(0, 255, 255, 0.4);
                                        border-radius: 6px;
                                        padding: 6px 12px;
                                        font-size: 12px;
                                        cursor: pointer;
                                        transition: all 0.3s ease;
                                    " onmouseover="this.style.background='rgba(0, 255, 255, 0.3)'" 
                                       onmouseout="this.style.background='rgba(0, 255, 255, 0.2)'">
                                        📋 复制代码
                                    </button>
                                </div>
                                <div style="background: rgba(255, 193, 7, 0.1); border-left: 4px solid #ffc107; padding: 12px; margin-top: 10px; border-radius: 6px;">
                                    <span style="color: #ffc107; font-weight: 600;">⚠️ 重要提示：</span>
                                    <span style="color: #e2e8f0;">必须绑定自定义域名（如：proxy.yourdomain.com），并优先使用自定义域名作为HOST代理域名，这样更稳定可靠</span>
                                </div>
                            </div>
                            
                            <!-- Pages 选项卡内容 -->
                            <div class="tab-panel" id="pages-panel">
                                <p style="color: #e2e8f0; margin-bottom: 15px; line-height: 1.6;">
                                    1️⃣ 下载压缩包 → 2️⃣ 进入Cloudflare Pages → 3️⃣ 上传项目 → 4️⃣ 部署完成
                                </p>
                                <button onclick="downloadProxyHost()" style="
                                    background: linear-gradient(135deg, rgba(251, 146, 60, 0.2) 0%, rgba(245, 101, 101, 0.2) 100%);
                                    color: #ffffff;
                                    border: 2px solid rgba(251, 146, 60, 0.5);
                                    border-radius: 8px;
                                    padding: 12px 20px;
                                    font-size: 14px;
                                    font-weight: 600;
                                    cursor: pointer;
                                    transition: all 0.3s ease;
                                    margin-bottom: 10px;
                                " onmouseover="this.style.borderColor='rgba(251, 146, 60, 0.7)'; this.style.background='linear-gradient(135deg, rgba(251, 146, 60, 0.3) 0%, rgba(245, 101, 101, 0.3) 100%)'" 
                                   onmouseout="this.style.borderColor='rgba(251, 146, 60, 0.5)'; this.style.background='linear-gradient(135deg, rgba(251, 146, 60, 0.2) 0%, rgba(245, 101, 101, 0.2) 100%)'">
                                    📦 下载 proxy_host.zip
                                </button>
                                <div style="background: rgba(0, 255, 157, 0.1); border-left: 4px solid #00ff9d; padding: 12px; border-radius: 6px;">
                                    <span style="color: #00ff9d; font-weight: 600;">✅ 部署成功后：</span>
                                    <span style="color: #e2e8f0;">使用你的Pages域名（如：your-project.pages.dev）作为代理域名</span>
                                </div>
                                <div style="background: rgba(255, 193, 7, 0.1); border-left: 4px solid #ffc107; padding: 12px; margin-top: 10px; border-radius: 6px;">
                                    <span style="color: #ffc107; font-weight: 600;">⚠️ 重要提示：</span>
                                    <span style="color: #e2e8f0;">建议绑定自定义域名（如：proxy.yourdomain.com），并优先使用自定义域名作为HOST代理域名，这样更稳定可靠</span>
                                </div>
                            </div>
                            
                            <!-- Snippets 选项卡内容 -->
                            <div class="tab-panel active" id="snippets-panel">
                                <p style="color: #e2e8f0; margin-bottom: 15px; line-height: 1.6;">
                                    1️⃣ 进入 规则(Rules) > Snippets → 2️⃣ 创建片段 → 3️⃣ 粘贴下方代码并部署 <br>→ 4️⃣ 片段规则 主机名 > 等于 > 自定义域名 <br>→ 5️⃣ 创建新代理DNS记录 > CNAME > 自定义域 > <strong><span onclick="copyToClipboard('cf.090227.xyz')" style="cursor: pointer; color: #00ff9d; text-decoration: underline;">cf.090227.xyz</span></strong>
                                </p>
                                
                                <!-- 源码选择器 -->
                                <div style="margin-bottom: 20px;">
                                    <label for="snippetSourceSelect" style="display: block; margin-bottom: 12px; color: #e2e8f0; font-weight: 600;">选择源码版本：</label>
                                    <select id="snippetSourceSelect" onchange="changeSnippetSource()">
                                        <option value="v" selected>🎯 白嫖哥源码</option>
                                        <option value="t12">📘 天书12源码</option>
                                        <option value="t13">📗 天书13源码(不支持ed配置)</option>
                                        <option value="my">🔥 ymyuuu源码(支持xhttp协议)</option>
                                        <option value="ca110us">🎠 ca110us源码(trojan协议)</option>
                                        <option value="ak">😂 AK优化源码(stallTCP优化传输机制)</option>
                                        <option value="gl">🚀 GoodLiux优化版</option>
                                    </select>
                                </div>

                                <!-- UUID 输入框和按钮 -->
                                <div style="margin-bottom: 20px;">
                                    <div style="display: flex; align-items: center; gap: 12px; margin-bottom: 10px;">
                                        <input type="text" id="snippetUuid" placeholder="UUID为空，节点将不做连接验证" style="
                                            flex: 1;
                                            padding: 12px 15px;
                                            background: rgba(26, 32, 44, 0.9);
                                            border: 2px solid rgba(0, 255, 255, 0.2);
                                            border-radius: 8px;
                                            color: #e2e8f0;
                                            font-family: 'JetBrains Mono', monospace;
                                            font-size: 14px;
                                            transition: all 0.3s ease;
                                        " oninput="updateSnippetCode()" onfocus="this.style.borderColor='#00ffff'; this.style.boxShadow='0 0 0 4px rgba(0, 255, 255, 0.2)'" onblur="this.style.borderColor='rgba(0, 255, 255, 0.2)'; this.style.boxShadow='none'">
                                        <button id="uuidButton" onclick="toggleUuid()" style="
                                            padding: 12px 20px;
                                            background: linear-gradient(135deg, rgba(0, 255, 157, 0.2) 0%, rgba(0, 255, 255, 0.2) 100%);
                                            color: #00ff9d;
                                            border: 2px solid rgba(0, 255, 157, 0.5);
                                            border-radius: 8px;
                                            font-size: 13px;
                                            font-weight: 600;
                                            cursor: pointer;
                                            transition: all 0.3s ease;
                                            white-space: nowrap;
                                        " onmouseover="this.style.background='linear-gradient(135deg, rgba(0, 255, 157, 0.3) 0%, rgba(0, 255, 255, 0.3) 100%)'; this.style.borderColor='rgba(0, 255, 157, 0.7)'" 
                                           onmouseout="updateUuidButtonStyle()">
                                            生成UUID验证
                                        </button>
                                    </div>
                                    
                                </div>
                                
                                <!-- 代码显示框 -->
                                <div style="position: relative;">
                                    <textarea readonly onclick="copySnippetCode()" style="
                                        width: 100%; 
                                        height: 238px; 
                                        background: #1a202c; 
                                        border: 2px solid rgba(0, 255, 255, 0.2);
                                        border-radius: 8px; 
                                        padding: 15px; 
                                        font-family: 'JetBrains Mono', monospace; 
                                        font-size: 13px; 
                                        color: #e2e8f0; 
                                        resize: vertical;
                                        line-height: 1.4;
                                        cursor: pointer;
                                        transition: all 0.3s ease;
                                    " id="snippetCode" title="点击复制代码">正在加载代码...</textarea>
                                    <button onclick="copySnippetCode()" style="
                                        position: absolute;
                                        top: 10px;
                                        right: 10px;
                                        background: rgba(0, 255, 255, 0.2);
                                        color: #00ffff;
                                        border: 1px solid rgba(0, 255, 255, 0.4);
                                        border-radius: 6px;
                                        padding: 6px 12px;
                                        font-size: 12px;
                                        cursor: pointer;
                                        transition: all 0.3s ease;
                                    " onmouseover="this.style.background='rgba(0, 255, 255, 0.3)'" 
                                       onmouseout="this.style.background='rgba(0, 255, 255, 0.2)'">
                                        📋 复制代码
                                    </button>
                                </div>
                                
                                <div style="background: rgba(255, 193, 7, 0.1); border-left: 4px solid #ffc107; padding: 12px; margin-top: 10px; border-radius: 6px;">
                                    <span style="color: #ffc107; font-weight: 600;">⚠️ 重要提示：</span>
                                    <span style="color: #e2e8f0;">部署后需要在 Snippet 规则中设置主机名匹配你的自定义域名，并填入HOST代理域名</span>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            
            <!-- 优选IP部分 -->
            <div class="section collapsible collapsed">
                <div class="section-title" onclick="toggleSection(this)">⚡️ 优选IP设置(可选)</div>
                <div class="section-content">
                    <!-- 优选IP模式选择 -->
                    <div class="form-group">
                        <label style="margin-bottom: 15px;">选择优选IP模式：</label>
                        <div class="proxy-mode-selector">
                            <label class="radio-option">
                                <input type="radio" name="ipMode" value="custom" checked onchange="toggleIPMode()">
                                <span class="radio-label">🎯 自定义优选IP</span>
                            </label>
                            <label class="radio-option">
                                <input type="radio" name="ipMode" value="subscription" onchange="toggleIPMode()">
                                <span class="radio-label">🔗 优选订阅生成器</span>
                            </label>
                        </div>
                    </div>
                    
                    <!-- 自定义优选IP输入框 -->
                    <div class="form-group" id="custom-ip-group">
                        <label for="ips">优选IP列表（每行一个地址）：</label>
                        <textarea id="ips" placeholder="ADD示例：&#10;www.visa.cn#优选域名&#10;127.0.0.1:1234#CFnat&#10;[2606:4700::]:2053#IPv6&#10;&#10;注意：&#10;每行一个地址，格式为 地址:端口#备注&#10;IPv6地址需要用中括号括起来，如：[2606:4700::]:2053&#10;端口不写，默认为 443 端口，如：visa.cn#优选域名&#10;&#10;ADDAPI示例：&#10;https://raw.githubusercontent.com/cmliu/WorkerVless2sub/main/addressesapi.txt&#10;&#10;注意：ADDAPI直接添加直链即可"></textarea>
                        <div class="example">📝 格式说明：
• 域名&IPv4: www.visa.cn#优选域名 或 127.0.0.1:1234#CFnat
• IPv6: [2606:4700::]:2053#IPv6地址
• ADDAPI: https://example.com/api.txt
• 每行一个地址，端口默认为443
                        </div>
                    </div>
                    
                    <!-- 优选订阅生成器输入框 -->
                    <div class="form-group" id="subscription-generator-group" style="display: none;">
                        <label for="subGenerator">优选订阅生成器地址：</label>
                        <input type="text" id="subGenerator" placeholder="sub.google.com" value="">
                        <div class="example">🔗 输入优选订阅生成器的域名地址，例如：sub.google.com
                        </div>
                    </div>
                </div>
            </div>
            
            <!-- PROXYIP部分 -->
            <div class="section collapsible collapsed">
                <div class="section-title" onclick="toggleSection(this)">🔧 落地IP设置(可选)</div>
                <div class="section-content">
                    <!-- 选项切换 -->
                    <div class="form-group">
                        <label style="margin-bottom: 15px;">选择连接方式：</label>
                        <div class="proxy-mode-selector">
                            <label class="radio-option">
                                <input type="radio" name="proxyMode" value="proxyip" checked onchange="toggleProxyMode()">
                                <span class="radio-label">🌐 ProxyIP 模式</span>
                            </label>
                            <label class="radio-option">
                                <input type="radio" name="proxyMode" value="socks5" onchange="toggleProxyMode()">
                                <span class="radio-label">🔒 Socks5 代理</span>
                            </label>
                            <label class="radio-option">
                                <input type="radio" name="proxyMode" value="http" onchange="toggleProxyMode()">
                                <span class="radio-label">📡 HTTP 代理</span>
                            </label>
                        </div>
                    </div>
                    
                    <!-- ProxyIP 输入框 -->
                    <div class="form-group" id="proxyip-group">
                        <!-- 标题行：ProxyIP地址 -->
                        <div class="socks5-header">
                            <label for="proxyip">ProxyIP地址：</label>
                            <span></span>
                        </div>
                        <input type="text" id="proxyip" placeholder="proxyip.fxxk.dedyn.io:443" value="">
                    </div>
                    
                    <!-- Socks5 输入框 -->
                    <div class="form-group" id="socks5-group" style="display: none;">
                        <!-- 标题行：Socks5代理 + 全局代理选项 -->
                        <div class="socks5-header">
                            <label for="socks5">Socks5代理：</label>
                            <label class="checkbox-option-inline" for="globalSocks5">
                                <input type="checkbox" id="globalSocks5">
                                <span class="checkbox-label-inline">🌍 启用全局代理</span>
                            </label>
                        </div>
                        <input type="text" id="socks5" placeholder="user:password@127.0.0.1:1080 或 127.0.0.1:1080" value="">
                    </div>
                    
                    <!-- HTTP 输入框 -->
                    <div class="form-group" id="http-group" style="display: none;">
                        <!-- 标题行：HTTP代理 + 全局代理选项 -->
                        <div class="socks5-header">
                            <label for="http">HTTP代理：</label>
                            <label class="checkbox-option-inline" for="globalHttp">
                                <input type="checkbox" id="globalHttp">
                                <span class="checkbox-label-inline">🌍 启用全局代理</span>
                            </label>
                        </div>
                        <input type="text" id="http" placeholder="user:password@127.0.0.1:8080 或 127.0.0.1:8080" value="">
                    </div>
                    
                    <!-- ProxyIP 详细说明 -->
                    <div style="margin-top: 24px;">
                        <h3 style="color: var(--text-primary); margin: 24px 0 16px;">📖 ProxyIP 概念</h3>
                        <p style="margin-bottom: 16px; line-height: 1.8; color: var(--text-secondary);">
                            在 Cloudflare 开发环境中，ProxyIP 特指那些能够成功代理连接到 Cloudflare 服务的第三方 IP 地址。
                        </p>
                        
                        <h3 style="color: var(--text-primary); margin: 24px 0 16px;">🔧 技术原理</h3>
                        <p style="margin-bottom: 16px; line-height: 1.8; color: var(--text-secondary);">
                            根据 Cloudflare 开发文档的 <a href="https://developers.cloudflare.com/workers/runtime-apis/tcp-sockets/" target="_blank" style="color: var(--primary-color); text-decoration: none;">TCP Sockets 官方文档</a> 说明，存在以下技术限制：
                        </p>
                        
                        <div class="code-block" style="background: #fff3cd; color: #856404; border-left: 4px solid var(--warning-color);">
                            ⚠️ Outbound TCP sockets to <a href="https://www.cloudflare.com/ips/" target="_blank" >Cloudflare IP ranges ↗</a>  are temporarily blocked, but will be re-enabled shortly.
                        </div>
                        
                        <p style="margin: 16px 0; line-height: 1.8; color: var(--text-secondary);">
                            这意味着 Cloudflare 开发环境无法直接连接到 Cloudflare 自有的 IP 地址段。为了解决这个限制，需要借助第三方云服务商的服务器作为"跳板"：
                        </p>
                        
                        <div class="proxy-flow-container">
                            <div class="proxy-flow">
                                <div class="proxy-step proxy-step-1">
                                    <div class="proxy-step-title">Cloudflare Workers</div>
                                    <div class="proxy-step-desc">发起请求</div>
                                </div>
                                <div class="proxy-arrow">→</div>
                                <div class="proxy-step proxy-step-2">
                                    <div class="proxy-step-title">ProxyIP 服务器</div>
                                    <div class="proxy-step-desc">第三方代理</div>
                                </div>
                                <div class="proxy-arrow">→</div>
                                <div class="proxy-step proxy-step-3">
                                    <div class="proxy-step-title">Cloudflare 服务</div>
                                    <div class="proxy-step-desc">目标服务</div>
                                </div>
                            </div>
                            <p class="proxy-explanation">
                                通过第三方服务器反向代理 Cloudflare 的 443 端口，实现对 Cloudflare 服务的访问
                            </p>
                        </div>
                    </div>
                </div>
            </div>
            
            <!-- 订阅转换设置 -->
            <div class="section collapsible collapsed">
                <div class="section-title" onclick="toggleSection(this)">⚙️ 订阅转换设置(可选)</div>
                <div class="section-content">
                    <div class="form-group">
                        <label for="subapi">订阅转换后端：</label>
                        <select id="subapiSelect" style="display: none; margin-bottom: 10px;">
                            <option value="">正在加载...</option>
                        </select>
                        <input type="text" id="subapi" placeholder="${subProtocol}://${subConverter.toLowerCase()}" value="" style="display: none;">
                        <div class="example">🔄 用于将生成的VLESS链接转换为Clash/SingBox等格式的后端服务
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="subconfig">订阅转换配置文件：</label>
                        <select id="subconfigSelect" style="display: none; margin-bottom: 10px;">
                            <option value="">正在加载...</option>
                        </select>
                        <input type="text" id="subconfig" placeholder="${subConfig}" value="" style="display: none;">
                        <div class="example">📋 订阅转换时使用的配置文件URL，定义规则和策略
                        </div>
                    </div>
                </div>
            </div>
            
            <!-- 高级参数设置 -->
            <div class="section collapsible">
                <div class="section-title" onclick="toggleSection(this)">🔧 节点高级设置</div>
                <div class="section-content">
                    <div class="form-group">
                        <label style="margin-bottom: 15px;">高级参数选项：</label>
                        <div class="advanced-params-container">
                            <label class="checkbox-option" for="enableEd">
                                <input type="checkbox" id="enableEd">
                                <span class="checkbox-label">🎯 启用 ed=2560</span>
                            </label>
                            <label class="checkbox-option" for="skipCertVerify">
                                <input type="checkbox" id="skipCertVerify">
                                <span class="checkbox-label">🔓 跳过证书验证</span>
                            </label>
                        </div>
                        <div class="example">⚙️ 高级参数说明：
• ed=2560：启用0-RTT
• scv：跳过TLS证书验证，适用于双向解析的免费域名
• xhttp：使用XHTTP协议必须保证域名开启gRPC支持
• trojan：使用trojan协议并开启验证UUID的话，要求在当前页面填写正确的UUID后再点击复制源码
                        </div>
                    </div>
                </div>
            </div>
            
            <!-- 生成按钮 -->
            <div class="button-container">
                <button class="generate-btn" onclick="generateSubscription()">
                    <span>🎉 生成订阅</span>
                </button>
                <button class="generate-btn short-url-btn" id="generateShortUrl" onclick="generateShortUrl()" disabled>
                    <span>🔗 生成短链</span>
                </button>
            </div>
            
            <!-- 结果显示 -->
            <div class="result-section" id="result-section">
                <div class="section-title">📋 订阅链接（点击复制）</div>
                <div class="result-url" id="subscriptionLink" onclick="copyToClipboard('subscriptionLink')"></div>
                
                <!-- 二维码显示 -->
                <div class="qr-container" id="qr-container">
                    <div class="qr-title">📱 手机扫码订阅</div>
                    <div class="qr-code" id="qrcode"></div>
                    <div class="qr-description">使用手机扫描二维码快速添加订阅</div> 
                </div>
            </div>
        </div>
        
        <div class="footer">
            <p>© 2025 BPSUB - Powered by Cloudflare Snippets | 感谢白嫖哥提供维护的 - <a href="https://t.me/v2rayByCf" target="_blank" class="thanks-link" title="访问Snipaste节点分享频道">🔗 Snipaste节点</a></p>
        </div>
    </div>
    
    <script>
        // 本地存储配置
        const STORAGE_KEY = 'bpsub_form_data';
        
        // 服务器端配置变量
        const DEFAULT_SUBAPI = '${subProtocol}://${subConverter.toLowerCase()}';
        const DEFAULT_SUBCONFIG = '${subConfig}';
        
        // 全局变量存储JSON数据
        let subApiData = null;
        let subConfigData = null;
        
        // 加载JSON配置
        async function loadJsonConfigs() {
            // 添加时间戳参数避免浏览器缓存
            const timestamp = Date.now();
            
            try {
                // 加载subapi.json
                const subApiResponse = await fetch('/subapi.json?t=' + timestamp);
                if (subApiResponse.ok) {
                    subApiData = await subApiResponse.json();
                    populateSubApiSelect();
                } else {
                    console.warn('Failed to load /subapi.json:', subApiResponse.status);
                    hideSubApiSelect();
                }
            } catch (error) {
                console.error('Error loading /subapi.json:', error);
                hideSubApiSelect();
            }
            
            try {
                // 加载subconfig.json
                const subConfigResponse = await fetch('/subconfig.json?t=' + timestamp);
                if (subConfigResponse.ok) {
                    subConfigData = await subConfigResponse.json();
                    populateSubConfigSelect();
                } else {
                    console.warn('Failed to load /subconfig.json:', subConfigResponse.status);
                    hideSubConfigSelect();
                }
            } catch (error) {
                console.error('Error loading /subconfig.json:', error);
                hideSubConfigSelect();
            }
        }
        
        // 填充subapi下拉框
        function populateSubApiSelect() {
            const select = document.getElementById('subapiSelect');
            const input = document.getElementById('subapi');
            
            if (!subApiData || !Array.isArray(subApiData)) {
                hideSubApiSelect();
                return;
            }
            
            // 清空现有选项
            select.innerHTML = '';
            
            // 添加选项
            subApiData.forEach(item => {
                const option = document.createElement('option');
                option.value = item.value;
                option.textContent = item.label;
                select.appendChild(option);
            });
            
            // 添加"自定义"选项
            const customOption = document.createElement('option');
            customOption.value = 'custom';
            customOption.textContent = '自定义';
            select.appendChild(customOption);
            
            // 显示下拉框
            select.style.display = 'block';
            
            // 检查是否有缓存的值需要设置
            const cachedValue = input.value;
            if (cachedValue) {
                if (cachedValue === 'custom' || subApiData.some(item => item.value === cachedValue)) {
                    select.value = cachedValue;
                    if (cachedValue === 'custom') {
                        input.style.display = 'block';
                        hideSubApiStatus();
                    } else {
                        input.style.display = 'none';
                    }
                } else {
                    // 如果缓存的值不在选项中，设置为自定义并显示输入框
                    select.value = 'custom';
                    input.style.display = 'block';
                    hideSubApiStatus();
                }
            } else {
                // 没有缓存，如果JSON加载成功，默认选中第一个选项，否则使用内置默认值
                if (subApiData && subApiData.length > 0) {
                    const firstOption = subApiData[0];
                    select.value = firstOption.value;
                    input.value = firstOption.value;
                    input.style.display = 'none';
                } else {
                    // JSON未加载成功，使用内置默认值
                    select.value = DEFAULT_SUBAPI;
                    input.value = DEFAULT_SUBAPI;
                    input.style.display = 'none';
                }
            }
            
            // 绑定change事件
            select.addEventListener('change', function() {
                if (this.value === 'custom') {
                    input.style.display = 'block';
                    input.focus();
                    hideSubApiStatus();
                } else {
                    input.value = this.value;
                    input.style.display = 'none';
                    checkSubApiVersion(this.value);
                }
                saveFormData();
            });
        }
        
        // 检查订阅转换后端版本（气泡式提醒）
        async function checkSubApiVersion(apiUrl) {
            const statusDiv = document.getElementById('subapiStatus');
            
            try {
                // 使用当前域名作为代理来检查版本，避免跨域问题
                const proxyUrl = '/check-version?url=' + encodeURIComponent(apiUrl);
                const response = await fetch(proxyUrl, {
                    method: 'GET'
                });
                
                if (response.ok) {
                    const result = await response.json();
                    if (result.success) {
                        showNotification('✅ 当前订阅转换后端可用<br>📌 ' + result.version, 'success');
                    } else {
                        throw new Error(result.error || '检查失败');
                    }
                } else {
                    throw new Error('HTTP ' + response.status);
                }
            } catch (error) {
                console.error('Version check failed:', error);
                showNotification('⚠️ 当前订阅转换后端异常 请更换订阅转换后端', 'error');
            }
        }
        
        // 显示右上角通知
        function showNotification(message, type) {
            if (!type) type = 'success';
            const container = document.getElementById('notification-container');
            
            // 创建通知元素
            const notification = document.createElement('div');
            notification.className = 'notification ' + type;
            
            const contentDiv = document.createElement('div');
            contentDiv.className = 'notification-content';
            contentDiv.innerHTML = message;
            
            const closeBtn = document.createElement('button');
            closeBtn.className = 'notification-close';
            closeBtn.innerHTML = '×';
            closeBtn.onclick = function() { closeNotification(this); };
            
            notification.appendChild(contentDiv);
            notification.appendChild(closeBtn);
            container.appendChild(notification);
            
            // 触发进入动画
            setTimeout(() => {
                notification.classList.add('show');
            }, 10);
            
            // 4秒后自动移除
            setTimeout(() => {
                closeNotification(notification.querySelector('.notification-close'));
            }, 4000);
        }
        
        // 关闭通知
        function closeNotification(closeBtn) {
            const notification = closeBtn.parentElement;
            notification.classList.remove('show');
            
            setTimeout(() => {
                if (notification.parentElement) {
                    notification.parentElement.removeChild(notification);
                }
            }, 400);
        }
        
        // 隐藏状态消息（保留函数以兼容现有调用）
        function hideSubApiStatus() {
            // 右上角通知不需要手动隐藏
        }
        
        // 填充subconfig下拉框
        function populateSubConfigSelect() {
            const select = document.getElementById('subconfigSelect');
            const input = document.getElementById('subconfig');
            
            if (!subConfigData || !Array.isArray(subConfigData)) {
                hideSubConfigSelect();
                return;
            }
            
            // 清空现有选项
            select.innerHTML = '';
            
            // 添加选项（嵌套结构）
            subConfigData.forEach(group => {
                if (group.label && group.options && Array.isArray(group.options)) {
                    // 创建optgroup
                    const optgroup = document.createElement('optgroup');
                    optgroup.label = group.label;
                    
                    group.options.forEach(option => {
                        const optionElement = document.createElement('option');
                        optionElement.value = option.value;
                        optionElement.textContent = option.label;
                        optgroup.appendChild(optionElement);
                    });
                    
                    select.appendChild(optgroup);
                }
            });
            
            // 添加"自定义"选项
            const customOption = document.createElement('option');
            customOption.value = 'custom';
            customOption.textContent = '自定义';
            select.appendChild(customOption);
            
            // 显示下拉框
            select.style.display = 'block';
            
            // 检查是否有缓存的值需要设置
            const cachedValue = input.value;
            if (cachedValue) {
                if (cachedValue === 'custom' || isValueInSubConfigData(cachedValue)) {
                    select.value = cachedValue;
                    if (cachedValue === 'custom') {
                        input.style.display = 'block';
                    } else {
                        input.style.display = 'none';
                    }
                } else {
                    // 如果缓存的值不在选项中，设置为自定义并显示输入框
                    select.value = 'custom';
                    input.style.display = 'block';
                }
            } else {
                // 没有缓存，如果JSON加载成功，默认选中第一个选项，否则使用内置默认值
                if (subConfigData && subConfigData.length > 0 && subConfigData[0].options && subConfigData[0].options.length > 0) {
                    const firstOption = subConfigData[0].options[0];
                    select.value = firstOption.value;
                    input.value = firstOption.value;
                    input.style.display = 'none';
                } else {
                    // JSON未加载成功，使用内置默认值
                    select.value = DEFAULT_SUBCONFIG;
                    input.value = DEFAULT_SUBCONFIG;
                    input.style.display = 'none';
                }
            }
            
            // 绑定change事件
            select.addEventListener('change', function() {
                if (this.value === 'custom') {
                    input.style.display = 'block';
                    input.focus();
                } else {
                    input.value = this.value;
                    input.style.display = 'none';
                }
                saveFormData();
            });
        }
        
        // 检查值是否在subConfigData中
        function isValueInSubConfigData(value) {
            if (!subConfigData || !Array.isArray(subConfigData)) return false;
            
            for (const group of subConfigData) {
                if (group.options && Array.isArray(group.options)) {
                    if (group.options.some(option => option.value === value)) {
                        return true;
                    }
                }
            }
            return false;
        }
        
        // 隐藏subapi下拉框
        function hideSubApiSelect() {
            const select = document.getElementById('subapiSelect');
            const input = document.getElementById('subapi');
            if (select) {
                select.style.display = 'none';
            }
            if (input) {
                input.style.display = 'block';
            }
        }
        
        // 隐藏subconfig下拉框
        function hideSubConfigSelect() {
            const select = document.getElementById('subconfigSelect');
            const input = document.getElementById('subconfig');
            if (select) {
                select.style.display = 'none';
            }
            if (input) {
                input.style.display = 'block';
            }
        }
        
        // 保存表单数据到localStorage
        function saveFormData() {
            // 强制使用 snippets 选项卡（因为前端只保留了 Snippets 部署选项）
            const currentTab = 'snippets';
            
            const formData = {
                ips: document.getElementById('ips').value,
                subGenerator: document.getElementById('subGenerator').value,
                proxyHost: document.getElementById('proxyHost').value,
                proxyip: document.getElementById('proxyip').value,
                socks5: document.getElementById('socks5').value,
                http: document.getElementById('http').value,
                subapi: document.getElementById('subapi').value,
                subconfig: document.getElementById('subconfig').value,
                snippetUuid: document.getElementById('snippetUuid') ? document.getElementById('snippetUuid').value : '',
                proxyMode: document.querySelector('input[name="proxyMode"]:checked')?.value || 'proxyip',
                ipMode: document.querySelector('input[name="ipMode"]:checked')?.value || 'custom',
                snippetSource: document.getElementById('snippetSourceSelect')?.value || 'v',
                globalSocks5: document.getElementById('globalSocks5').checked,
                globalHttp: document.getElementById('globalHttp').checked,
                enableEd: document.getElementById('enableEd') ? document.getElementById('enableEd').checked : false,
                skipCertVerify: document.getElementById('skipCertVerify') ? document.getElementById('skipCertVerify').checked : false,
                activeTab: currentTab, // 保存当前选中的选项卡
                // 保存所有可折叠section的状态
                sectionStates: getSectionStates(),
                timestamp: Date.now()
            };
            
            try {
                localStorage.setItem(STORAGE_KEY, JSON.stringify(formData));
                console.log('表单数据已保存到本地缓存');
            } catch (error) {
                console.error('保存表单数据失败:', error);
            }
        }
        
        // 从localStorage加载表单数据
        function loadFormData() {
            try {
                const savedData = localStorage.getItem(STORAGE_KEY);
                if (!savedData) {
                    console.log('未找到缓存的表单数据');
                    return;
                }
                
                const formData = JSON.parse(savedData);
                console.log('加载缓存的表单数据:', formData);
                
                // 填充表单字段
                if (formData.ips) document.getElementById('ips').value = formData.ips;
                if (formData.subGenerator) document.getElementById('subGenerator').value = formData.subGenerator;
                if (formData.proxyHost) document.getElementById('proxyHost').value = formData.proxyHost;
                if (formData.proxyip) document.getElementById('proxyip').value = formData.proxyip;
                if (formData.socks5) document.getElementById('socks5').value = formData.socks5;
                if (formData.http) document.getElementById('http').value = formData.http;
                if (formData.subapi) document.getElementById('subapi').value = formData.subapi;
                if (formData.subconfig) document.getElementById('subconfig').value = formData.subconfig;
                if (formData.snippetUuid && document.getElementById('snippetUuid')) {
                    document.getElementById('snippetUuid').value = formData.snippetUuid;
                    // 更新按钮状态和代码
                    updateUuidButtonStyle();
                    updateSnippetCode();
                }
                
                // 设置IP模式
                if (formData.ipMode) {
                    const ipModeRadio = document.querySelector('input[name="ipMode"][value="' + formData.ipMode + '"]');
                    if (ipModeRadio) {
                        ipModeRadio.checked = true;
                        toggleIPMode();
                    }
                }
                
                // 设置代理模式
                if (formData.proxyMode) {
                    const proxyModeRadio = document.querySelector('input[name="proxyMode"][value="' + formData.proxyMode + '"]');
                    if (proxyModeRadio) {
                        proxyModeRadio.checked = true;
                        toggleProxyMode();
                    }
                }
                
                // 设置源码选择
                if (formData.snippetSource) {
                    const snippetSourceSelect = document.getElementById('snippetSourceSelect');
                    if (snippetSourceSelect) {
                        snippetSourceSelect.value = formData.snippetSource;
                        changeSnippetSource();
                    }
                }
                
                // 强制使用 snippets 选项卡（因为前端只保留了 Snippets 部署选项）
                console.log('强制切换到 snippets 选项卡');
                switchTab('snippets');
                
                // 设置全局Socks5选项
                if (formData.globalSocks5 !== undefined) {
                    document.getElementById('globalSocks5').checked = formData.globalSocks5;
                    // 手动触发change事件更新样式
                    document.getElementById('globalSocks5').dispatchEvent(new Event('change'));
                }
                
                // 设置全局HTTP选项
                if (formData.globalHttp !== undefined) {
                    document.getElementById('globalHttp').checked = formData.globalHttp;
                    // 手动触发change事件更新样式
                    document.getElementById('globalHttp').dispatchEvent(new Event('change'));
                }
                
                // 恢复section折叠/展开状态
                if (formData.sectionStates) {
                    applySectionStates(formData.sectionStates);
                }

                // 设置高级参数选项
                if (formData.enableEd !== undefined && document.getElementById('enableEd')) {
                    document.getElementById('enableEd').checked = formData.enableEd;
                    // 手动触发change事件更新样式
                    document.getElementById('enableEd').dispatchEvent(new Event('change'));
                }
                
                if (formData.skipCertVerify !== undefined && document.getElementById('skipCertVerify')) {
                    document.getElementById('skipCertVerify').checked = formData.skipCertVerify;
                    // 手动触发change事件更新样式
                    document.getElementById('skipCertVerify').dispatchEvent(new Event('change'));
                }
                
                console.log('表单数据加载完成');
            } catch (error) {
                console.error('加载表单数据失败:', error);
            }
        }
        

        
        // 设置表单字段的自动保存事件监听器
        function setupAutoSave() {
            const fields = ['ips', 'subGenerator', 'proxyHost', 'proxyip', 'socks5', 'http', 'subapi', 'subconfig', 'snippetUuid'];
            
            // 为文本输入字段添加事件监听
            fields.forEach(fieldId => {
                const element = document.getElementById(fieldId);
                if (element) {
                    // 使用防抖函数避免频繁保存
                    let saveTimeout;
                    const debouncedSave = () => {
                        clearTimeout(saveTimeout);
                        saveTimeout = setTimeout(saveFormData, 1000); // 1秒后保存
                    };
                    
                    // 为subapi和subconfig添加特殊处理：同步更新下拉框
                    if (fieldId === 'subapi' || fieldId === 'subconfig') {
                        element.addEventListener('input', function() {
                            // 同步更新对应的下拉框
                            const selectId = fieldId + 'Select';
                            const select = document.getElementById(selectId);
                            if (select && select.style.display !== 'none') {
                                // 如果输入的值不在预设选项中，设置为自定义
                                const isInOptions = fieldId === 'subapi' 
                                    ? (subApiData && subApiData.some(item => item.value === this.value))
                                    : isValueInSubConfigData(this.value);
                                
                                if (!isInOptions && this.value.trim() !== '') {
                                    select.value = 'custom';
                                } else if (isInOptions) {
                                    select.value = this.value;
                                }
                            }
                            debouncedSave();
                        });
                        element.addEventListener('change', function() {
                            // 同步更新对应的下拉框
                            const selectId = fieldId + 'Select';
                            const select = document.getElementById(selectId);
                            if (select && select.style.display !== 'none') {
                                // 如果输入的值不在预设选项中，设置为自定义
                                const isInOptions = fieldId === 'subapi' 
                                    ? (subApiData && subApiData.some(item => item.value === this.value))
                                    : isValueInSubConfigData(this.value);
                                
                                if (!isInOptions && this.value.trim() !== '') {
                                    select.value = 'custom';
                                } else if (isInOptions) {
                                    select.value = this.value;
                                }
                            }
                            saveFormData();
                        });
                    } else if (fieldId === 'proxyHost' || fieldId === 'subGenerator') {
                        element.addEventListener('input', function() {
                            // 清除之前的定时器
                            clearTimeout(this._extractTimeout);
                            
                            // 设置新的定时器，500ms后自动提取域名
                            this._extractTimeout = setTimeout(() => {
                                const originalValue = this.value;
                                const extractedDomain = extractDomain(originalValue);
                                
                                if (extractedDomain !== originalValue && extractedDomain) {
                                    this.value = extractedDomain;
                                    // 触发保存
                                    saveFormData();
                                    
                                    // 显示提示
                                    showDomainExtractionNotice(originalValue, extractedDomain);
                                }
                            }, 500);
                            
                            // 正常的防抖保存
                            debouncedSave();
                        });
                        
                        element.addEventListener('change', function() {
                            const originalValue = this.value;
                            const extractedDomain = extractDomain(originalValue);
                            
                            if (extractedDomain !== originalValue && extractedDomain) {
                                this.value = extractedDomain;
                                showDomainExtractionNotice(originalValue, extractedDomain);
                            }
                            
                            saveFormData();
                        });
                    } else {
                        element.addEventListener('input', debouncedSave);
                        element.addEventListener('change', saveFormData);
                    }
                }
            });
            
            // 为IP模式单选框添加事件监听
            document.querySelectorAll('input[name="ipMode"]').forEach(radio => {
                radio.addEventListener('change', saveFormData);
            });
            
            // 为代理模式单选框添加事件监听
            document.querySelectorAll('input[name="proxyMode"]').forEach(radio => {
                radio.addEventListener('change', saveFormData);
            });
            
            // 为源码选择下拉框添加事件监听
            const snippetSourceSelect = document.getElementById('snippetSourceSelect');
            if (snippetSourceSelect) {
                snippetSourceSelect.addEventListener('change', saveFormData);
            }
            
            // 为复选框添加事件监听
            const globalSocks5Checkbox = document.getElementById('globalSocks5');
            if (globalSocks5Checkbox) {
                globalSocks5Checkbox.addEventListener('change', saveFormData);
            }
            
            const globalHttpCheckbox = document.getElementById('globalHttp');
            if (globalHttpCheckbox) {
                globalHttpCheckbox.addEventListener('change', saveFormData);
            }
            
            // 为高级参数复选框添加事件监听
            const enableEdCheckbox = document.getElementById('enableEd');
            if (enableEdCheckbox) {
                enableEdCheckbox.addEventListener('change', saveFormData);
            }
            
            const skipCertVerifyCheckbox = document.getElementById('skipCertVerify');
            if (skipCertVerifyCheckbox) {
                skipCertVerifyCheckbox.addEventListener('change', saveFormData);
            }
        }
        
        function generateSubscription() {
            const ips = document.getElementById('ips').value.trim();
            const subGenerator = document.getElementById('subGenerator').value.trim();
            const proxyHost = document.getElementById('proxyHost').value.trim();
            const proxyip = document.getElementById('proxyip').value.trim();
            const socks5 = document.getElementById('socks5').value.trim();
            const http = document.getElementById('http').value.trim();
            const subapi = document.getElementById('subapi').value.trim();
            const subconfig = document.getElementById('subconfig').value.trim();
            const hostLength = ${hostLength};
            
            // 获取当前选中的选项卡
            const activeTab = document.querySelector('.tab-button.active');
            const currentTab = activeTab ? activeTab.id.replace('-tab', '') : 'workers';
            
            // 检查代理域名是否为空
            if (!proxyHost && hostLength < 1) {
                alert('⚠️ 代理域名不能为空！\\n\\n请输入代理域名，例如：proxy.pages.dev');
                return;
            }
            
            // 特别检查：CF Snippets 部署必须要有 HOST
            if (currentTab === 'snippets' && !proxyHost) {
                alert('⚠️ 使用 CF Snippets 部署时，HOST 域名不能为空！\\n\\n请输入你的自定义域名，Snippets 规则需要匹配具体的主机名。\\n\\n例如：proxy.yourdomain.com');
                return;
            }
            
            // 获取选择的IP模式和代理模式
            const ipMode = document.querySelector('input[name="ipMode"]:checked').value;
            const proxyMode = document.querySelector('input[name="proxyMode"]:checked').value;
            
            // 保存当前表单数据
            saveFormData();
            
            // 获取当前域名和协议
            const currentDomain = window.location.host;
            const currentProtocol = window.location.protocol || 'https:'; // 获取当前协议 (http: 或 https:)
            let url = \`\${currentProtocol}//\${currentDomain}/sub\`;
            
            const params = new URLSearchParams();
            
            if (proxyHost) params.append('host', proxyHost);
            
            // 根据IP模式处理参数
            if (ipMode === 'subscription') {
                // 优选订阅生成器模式
                if (!subGenerator) {
                    alert('⚠️ 选择优选订阅生成器模式时，订阅生成器地址不能为空！\\n\\n请输入订阅生成器地址或切换到自定义优选IP模式。');
                    return;
                }
                params.append('sub', subGenerator);
            } else {
                // 自定义优选IP模式
                if (ips) {
                    // 将每行转换为用|分隔的格式
                    const ipsArray = ips.split('\\n').filter(line => line.trim()).map(line => line.trim());
                    if (ipsArray.length > 0) {
                        params.append('ips', ipsArray.join('|'));
                    }
                }
            }
            
            // 根据选择的模式处理代理设置
            if (proxyMode === 'socks5') {
                // 处理Socks5模式
                if (!socks5) {
                    alert('⚠️ 选择Socks5模式时，Socks5代理地址不能为空！\\n\\n请输入Socks5地址或切换到ProxyIP模式。');
                    return;
                }
                
                // 智能处理并验证Socks5格式
                const processedSocks5 = processSocks5(socks5);
                if (!processedSocks5) {
                    alert('⚠️ Socks5格式不正确！\\n\\n请检查输入格式，例如：\\n• user:password@127.0.0.1:1080\\n• 127.0.0.1:1080');
                    return;
                }
                
                params.append('socks5', processedSocks5);
                
                // 检查是否启用全局Socks5
                const globalSocks5 = document.getElementById('globalSocks5').checked;
                if (globalSocks5) {
                    params.append('global', 'true');
                }
            } else if (proxyMode === 'http') {
                // 处理HTTP代理模式
                const http = document.getElementById('http').value.trim();
                if (!http) {
                    alert('⚠️ 选择HTTP代理模式时，HTTP代理地址不能为空！\\n\\n请输入HTTP代理地址或切换到ProxyIP模式。');
                    return;
                }
                
                // 智能处理并验证HTTP格式（复用socks5的处理函数）
                const processedHttp = processSocks5(http);
                if (!processedHttp) {
                    alert('⚠️ HTTP代理格式不正确！\\n\\n请检查输入格式，例如：\\n• user:password@127.0.0.1:8080\\n• 127.0.0.1:8080');
                    return;
                }
                
                params.append('http', processedHttp);
                
                // 检查是否启用全局HTTP代理
                const globalHttp = document.getElementById('globalHttp').checked;
                if (globalHttp) {
                    params.append('global', 'true');
                }
            } else {
                // 处理ProxyIP模式
                if (proxyip) {
                    // 智能处理 proxyip 格式
                    let processedProxyip = processProxyIP(proxyip);
                    params.append('proxyip', processedProxyip);
                }
            }
            
            // 处理订阅转换后端（当选择内置默认后端时不添加参数）
            if (subapi && subapi !== DEFAULT_SUBAPI) {
                params.append('subapi', subapi);
            }
            
            // 处理订阅转换配置（当选择内置默认规则时不添加参数）
            if (subconfig && subconfig !== DEFAULT_SUBCONFIG) {
                params.append('subconfig', subconfig);
            }
            
            // 检查是否选择了 Snippets 部署且有 UUID
            if (activeTab && activeTab.id === 'snippets-tab') {
                const snippetUuid = document.getElementById('snippetUuid').value.trim();
                if (snippetUuid) {
                    params.append('uuid', snippetUuid);
                }
            }
            
            // 处理高级参数
            const enableEd = document.getElementById('enableEd').checked;
            const skipCertVerify = document.getElementById('skipCertVerify').checked;
            
            // 添加 ed=2560 参数（如果启用且不是天书13或ak源码）
            if (enableEd) {
                // 检查是否为天书13或ak源码
                const selectedSource = getSelectedSnippetSource();
                const isSnippetsTab = activeTab && activeTab.id === 'snippets-tab';
                
                if (!isSnippetsTab || (selectedSource !== 't13' && selectedSource !== 'ak')) {
                    params.append('ed', '2560');
                }
            }
            
            // 添加 scv 参数（跳过证书验证）
            if (skipCertVerify) {
                params.append('scv', 'true');
            }
            
            // 检查是否选择了 ymyuuu 源码，如果是则添加 xhttp=true 参数
            // 检查是否选择了 ca110us 源码，如果是则添加 trojan=true 参数
            const isSnippetsTab = activeTab && activeTab.id === 'snippets-tab';
            if (isSnippetsTab) {
                const selectedSource = getSelectedSnippetSource();
                if (selectedSource === 'my') {
                    params.append('xhttp', 'true');
                } else if (selectedSource === 'ca110us') {
                    params.append('trojan', 'true');
                }
            }
            
            // 组合最终URL
            const queryString = params.toString();
            if (queryString) {
                url += '?' + queryString;
            }
            
            // 显示结果
            const resultSection = document.getElementById('result-section');
            const resultUrl = document.getElementById('subscriptionLink');
            const qrContainer = document.getElementById('qr-container');
            const shortUrlBtn = document.getElementById('generateShortUrl');
            
            // 存储原始URL到全局变量
            cpurl = url;
            resultUrl.textContent = url;
            resultSection.style.display = 'block';
            
            // 启用短链按钮
            shortUrlBtn.disabled = false;
            
            // 生成二维码
            generateQRCode(url);
            
            // 显示二维码容器
            qrContainer.style.display = 'block';
            
            // 滚动到结果区域
            resultSection.scrollIntoView({ behavior: 'smooth' });
        }
        
        // 生成短链接函数
        function generateShortUrl() {
            const shortUrlBtn = document.getElementById('generateShortUrl');
            if (shortUrlBtn.disabled) return;
            
            // 添加点击效果
            shortUrlBtn.style.transform = 'scale(0.95)';
            setTimeout(() => {
                shortUrlBtn.style.transform = '';
            }, 200);
            
            // 使用存储的cpurl而不是页面文本
            const subscriptionLink = cpurl;
            const subscriptionLinkElement = document.getElementById('subscriptionLink');
            
            // 显示加载状态
            subscriptionLinkElement.textContent = "正在生成短链接...";
            
            // Base64编码
            const base64Encoded = btoa(subscriptionLink);
            
            // 发送POST请求到短链接服务
            fetch('https://v1.mk/short', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                },
                body: 'longUrl=' + encodeURIComponent(base64Encoded)
            })
            .then(response => response.json())
            .then(data => {
                console.log("短链接响应:", data);
                if (data.Code === 1 && data.ShortUrl) {
                    // 更新cpurl为短链接
                    cpurl = data.ShortUrl;
                    subscriptionLinkElement.textContent = data.ShortUrl;
                    // 使用原有样式更新二维码
                    generateQRCode(data.ShortUrl);
                    subscriptionLinkElement.classList.add('copied');
                    setTimeout(() => {
                        subscriptionLinkElement.classList.remove('copied');
                    }, 300);
                } else {
                    subscriptionLinkElement.textContent = "短链接生成失败，请重试";
                }
            })
            .catch(error => {
                console.error("生成短链接错误:", error);
                subscriptionLinkElement.textContent = "短链接生成失败，请重试";
            });
        }
        
        function copyToClipboard(elementIdOrText = 'subscriptionLink') {
            let url, element;
            
            // 判断参数是元素ID还是直接的文本
            if (document.getElementById(elementIdOrText)) {
                // 如果是元素ID
                element = document.getElementById(elementIdOrText);
                // 如果是订阅链接，使用存储的cpurl而不是页面文本
                if (elementIdOrText === 'subscriptionLink' && cpurl) {
                    url = cpurl;
                } else {
                    url = element.textContent;
                }
            } else {
                // 如果是直接的文本
                url = elementIdOrText;
                element = null;
            }
            
            // 使用 Clipboard API
            if (navigator.clipboard && window.isSecureContext) {
                navigator.clipboard.writeText(url).then(() => {
                    if (element) {
                        showCopySuccess(element);
                    } else {
                        showToast('✅ 复制成功！' + url + ' 已复制到剪贴板');
                    }
                }).catch(err => {
                    // 降级到传统方法
                    fallbackCopyTextToClipboard(url, element);
                });
            } else {
                // 降级到传统方法
                fallbackCopyTextToClipboard(url, element);
            }
        }
        
        function fallbackCopyTextToClipboard(text, element) {
            const textArea = document.createElement("textarea");
            textArea.value = text;
            
            // 避免在iOS上的滚动问题
            textArea.style.top = "0";
            textArea.style.left = "0";
            textArea.style.position = "fixed";
            
            document.body.appendChild(textArea);
            textArea.focus();
            textArea.select();
            
            try {
                document.execCommand('copy');
                if (element) {
                    showCopySuccess(element);
                } else {
                    showToast('✅ 复制成功！' + text + ' 已复制到剪贴板');
                }
            } catch (err) {
                alert('复制失败，请手动复制链接');
            }
            
            document.body.removeChild(textArea);
        }
        
        function showCopySuccess(element) {
            const originalClass = element.className;
            const originalText = element.textContent;
            
            element.classList.add('copy-success');
            element.textContent = '✅ 复制成功！链接已复制到剪贴板';
            
            setTimeout(() => {
                element.className = originalClass;
                // 如果是订阅链接元素，恢复时使用最新的cpurl，否则使用原始文本
                if (element.id === 'subscriptionLink' && cpurl) {
                    element.textContent = cpurl;
                } else {
                    element.textContent = originalText;
                }
            }, 2000);
        }
        
        function showToast(message) {
            // 创建toast元素
            const toast = document.createElement('div');
            toast.textContent = message;
            toast.style.cssText = 'position: fixed; top: 20px; right: 20px; background: rgba(0, 255, 157, 0.9); color: #1a202c; padding: 12px 20px; border-radius: 8px; font-weight: 600; z-index: 10000; box-shadow: 0 4px 12px rgba(0, 255, 157, 0.3); transition: all 0.3s ease;';
            
            document.body.appendChild(toast);
            
            // 3秒后自动移除
            setTimeout(() => {
                toast.style.opacity = '0';
                toast.style.transform = 'translateX(100%)';
                setTimeout(() => {
                    if (document.body.contains(toast)) {
                        document.body.removeChild(toast);
                    }
                }, 300);
            }, 3000);
        }
        
        // 生成二维码
        function generateQRCode(url) {
            const qrCodeElement = document.getElementById('qrcode');
            
            // 清空之前的二维码
            qrCodeElement.innerHTML = '';
            
            // 生成新的二维码
            try {
                const qr = new QRCode(qrCodeElement, {
                    text: url,
                    width: 200,
                    height: 200,
                    colorDark: "#1a202c",
                    colorLight: "#ffffff",
                    correctLevel: QRCode.CorrectLevel.M
                });
            } catch (error) {
                console.error('生成二维码失败:', error);
                qrCodeElement.innerHTML = '<div style="color: #ff6b6b; padding: 20px;">二维码生成失败</div>';
            }
        }
        
        // 获取所有可折叠section的状态
        function getSectionStates() {
            const states = {};
            const sections = document.querySelectorAll('.section.collapsible');
            sections.forEach((section, index) => {
                const titleElement = section.querySelector('.section-title');
                if (titleElement) {
                    const title = titleElement.textContent.trim();
                    states[title] = !section.classList.contains('collapsed');
                }
            });
            return states;
        }

        // 应用section状态
        function applySectionStates(states) {
            if (!states) return;
            
            const sections = document.querySelectorAll('.section.collapsible');
            sections.forEach((section, index) => {
                const titleElement = section.querySelector('.section-title');
                if (titleElement) {
                    const title = titleElement.textContent.trim();
                    if (states.hasOwnProperty(title)) {
                        const shouldBeExpanded = states[title];
                        if (shouldBeExpanded) {
                            section.classList.remove('collapsed');
                        } else {
                            section.classList.add('collapsed');
                        }
                    }
                }
            });
        }

        // 折叠功能
        function toggleSection(element) {
            const section = element.parentElement;
            section.classList.toggle('collapsed');
            // 状态改变后保存到缓存
            saveFormData();
        }
        
        // 选项卡切换函数
        function switchTab(tabName) {
            // 移除所有活动状态
            document.querySelectorAll('.tab-button').forEach(btn => btn.classList.remove('active'));
            document.querySelectorAll('.tab-panel').forEach(panel => panel.classList.remove('active'));
            
            // 激活当前选项卡
            document.getElementById(tabName + '-tab').classList.add('active');
            document.getElementById(tabName + '-panel').classList.add('active');
            
            // 检查ed选项的可用性
            checkEdOptionAvailability();
            
            // 检查HTTP代理选项的可用性
            checkHttpProxyAvailability(tabName);
            
            // 保存当前选项卡状态到缓存
            saveFormData();
        }
        
        // 检查HTTP代理选项的可用性
        function checkHttpProxyAvailability(currentTab) {
            const httpRadio = document.querySelector('input[name="proxyMode"][value="http"]');
            const httpRadioOption = httpRadio.closest('.radio-option');
            const currentProxyMode = document.querySelector('input[name="proxyMode"]:checked').value;
            
            if (currentTab === 'snippets') {
                // Snippets模式：启用HTTP代理选项
                httpRadio.disabled = false;
                httpRadioOption.classList.remove('disabled');
            } else {
                // 其他模式：禁用HTTP代理选项
                httpRadio.disabled = true;
                httpRadioOption.classList.add('disabled');
                
                // 如果当前选择的是HTTP代理，自动切换到ProxyIP模式
                if (currentProxyMode === 'http') {
                    const proxyipRadio = document.querySelector('input[name="proxyMode"][value="proxyip"]');
                    proxyipRadio.checked = true;
                    toggleProxyMode();
                }
            }
        }
        
        // 加载Worker代码
        async function loadWorkerCode() {
            try {
                const workerJsUrl = GITHUB_PROXY + 'https://raw.githubusercontent.com/cmliu/CF-Workers-BPSUB/main/proxy_host/_worker.js';
                const response = await fetch(workerJsUrl);
                if (!response.ok) {
                    throw new Error('获取代码失败');
                }
                const code = await response.text();
                document.getElementById('workerCode').value = code;
            } catch (error) {
                console.error('加载Worker代码失败:', error);
                document.getElementById('workerCode').value = '加载代码失败，请自行从\\nhttps://raw.githubusercontent.com/cmliu/CF-Workers-BPSUB/main/proxy_host/_worker.js\\n获取最新代码';
            }
        }
        
        // 复制Worker代码
        function copyWorkerCode() {
            const workerCodeElement = document.getElementById('workerCode');
            const code = workerCodeElement.value;
            
            // 添加点击视觉反馈
            workerCodeElement.style.background = 'rgba(0, 255, 255, 0.1)';
            workerCodeElement.style.borderColor = 'rgba(0, 255, 255, 0.6)';
            
            if (navigator.clipboard && window.isSecureContext) {
                navigator.clipboard.writeText(code).then(() => {
                    showCopySuccessForCodeBox();
                }).catch(err => {
                    fallbackCopyTextToClipboard(code, workerCodeElement);
                    showCopySuccessForCodeBox();
                });
            } else {
                fallbackCopyTextToClipboard(code, workerCodeElement);
                showCopySuccessForCodeBox();
            }
        }
        
        // 下载代理主机压缩包
        function downloadProxyHost() {
            const currentDomain = window.location.host;
            const downloadUrl = \`https://\${currentDomain}/proxy_host.zip\`;
            
            // 创建临时下载链接
            const link = document.createElement('a');
            link.href = downloadUrl;
            link.download = 'proxy_host.zip';
            link.style.display = 'none';
            document.body.appendChild(link);
            link.click();
            document.body.removeChild(link);
            
            // 显示下载提示
            showDownloadSuccess();
        }

        // UUID 生成函数
        function generateUUID() {
            return 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, function(c) {
                const r = Math.random() * 16 | 0;
                const v = c == 'x' ? r : (r & 0x3 | 0x8);
                return v.toString(16);
            });
        }

        // UUID 按钮切换函数
        function toggleUuid() {
            const uuidInput = document.getElementById('snippetUuid');
            const uuidButton = document.getElementById('uuidButton');
            
            if (uuidInput.value.trim() === '') {
                // 生成随机 UUID
                uuidInput.value = generateUUID();
                updateUuidButtonStyle();
                updateSnippetCode();
            } else {
                // 清除 UUID
                uuidInput.value = '';
                updateUuidButtonStyle();
                updateSnippetCode();
            }
        }

        // 更新 UUID 按钮样式和文本
        function updateUuidButtonStyle() {
            const uuidInput = document.getElementById('snippetUuid');
            const uuidButton = document.getElementById('uuidButton');
            
            if (uuidInput.value.trim() === '') {
                uuidButton.textContent = '生成UUID验证';
                uuidButton.style.background = 'linear-gradient(135deg, rgba(0, 255, 157, 0.2) 0%, rgba(0, 255, 255, 0.2) 100%)';
                uuidButton.style.borderColor = 'rgba(0, 255, 157, 0.5)';
                uuidButton.style.color = '#00ff9d';
            } else {
                uuidButton.textContent = '取消UUID验证';
                uuidButton.style.background = 'linear-gradient(135deg, rgba(255, 99, 71, 0.2) 0%, rgba(255, 165, 0, 0.2) 100%)';
                uuidButton.style.borderColor = 'rgba(255, 99, 71, 0.5)';
                uuidButton.style.color = '#ff6347';
            }
        }

        let snippetCodeCache = '';
        
        // GitHub代理配置
        const GITHUB_PROXY = 'https://github.cmliussss.net/';
        
        // 存储当前订阅URL
        let cpurl = '';

        // 源码URL映射
        const snippetUrlMap = {
            'v': 'https://raw.githubusercontent.com/cmliu/CF-Workers-BPSUB/main/snippet/v.js',
            't12': 'https://raw.githubusercontent.com/cmliu/CF-Workers-BPSUB/main/snippet/t12.js', 
            't13': 'https://raw.githubusercontent.com/cmliu/CF-Workers-BPSUB/main/snippet/t13.js',
            'my': 'https://raw.githubusercontent.com/cmliu/CF-Workers-BPSUB/main/snippet/my.js',
            'ca110us': 'https://raw.githubusercontent.com/cmliu/CF-Workers-BPSUB/main/snippet/ca110us.js',
            'ak': 'https://raw.githubusercontent.com/cmliu/CF-Workers-BPSUB/main/snippet/ak.js',
            'gl': 'https://raw.githubusercontent.com/cmliu/CF-Workers-BPSUB/main/snippet/gl.js'
        };

        // 获取当前选中的源码类型
        function getSelectedSnippetSource() {
            const selectElement = document.getElementById('snippetSourceSelect');
            return selectElement ? selectElement.value : 'v';
        }

        // 加载 Snippet 代码
        async function loadSnippetCode() {
            const sourceType = getSelectedSnippetSource();
            const snippetJsUrl = snippetUrlMap[sourceType];
            
            try {
                const response = await fetch(GITHUB_PROXY + snippetJsUrl);
                if (!response.ok) {
                    throw new Error('获取代码失败');
                }
                const code = await response.text();
                snippetCodeCache = code;
                updateSnippetCode();
            } catch (error) {
                console.error('加载Snippet代码失败:', error);
                document.getElementById('snippetCode').value = \`加载代码失败，请自行从\\n\${snippetJsUrl}\\n获取最新代码\`;
            }
        }

        // 源码选择变更处理函数
        function changeSnippetSource() {
            // 重新加载对应的源码
            loadSnippetCode();
            
            // 检查ed选项的可用性
            checkEdOptionAvailability();
            
            // 保存到缓存
            saveFormData();
        }

        // 检查ed选项的可用性
        function checkEdOptionAvailability() {
            const enableEdCheckbox = document.getElementById('enableEd');
            const enableEdOption = enableEdCheckbox ? enableEdCheckbox.closest('.checkbox-option') : null;
            
            if (enableEdCheckbox && enableEdOption) {
                const selectedSource = getSelectedSnippetSource();
                const activeTab = document.querySelector('.tab-button.active');
                const isSnippetsTab = activeTab && activeTab.id === 'snippets-tab';
                
                if (isSnippetsTab && (selectedSource === 't13' || selectedSource === 'ak')) {
                    // 天书13源码不支持ed参数，禁用选项
                    enableEdCheckbox.disabled = true;
                    enableEdCheckbox.checked = false;
                    enableEdOption.style.opacity = '0.5';
                    enableEdOption.style.pointerEvents = 'none';
                    enableEdOption.title = '天书13、ak源码不支持ed参数配置';
                } else {
                    // 其他情况启用选项
                    enableEdCheckbox.disabled = false;
                    enableEdOption.style.opacity = '1';
                    enableEdOption.style.pointerEvents = 'auto';
                    enableEdOption.title = '';
                }
            }
        }

        // 更新 Snippet 代码
        function updateSnippetCode() {
            const uuidInput = document.getElementById('snippetUuid');
            const snippetCodeElement = document.getElementById('snippetCode');
            
            if (snippetCodeCache) {
                const uuid = uuidInput.value.trim();
                let processedUuid = uuid;
                
                // 检查当前选择的源码类型
                const selectedSource = getSelectedSnippetSource();
                
                // 如果选择的是ca110us源码且UUID不为空，则进行sha224处理
                if (selectedSource === 'ca110us' && uuid !== '') {
                    try {
                        // 使用sha224函数处理UUID
                        if (typeof window.sha224 !== 'undefined') {
                            processedUuid = window.sha224(uuid);
                            console.log('🎯 使用 window.sha224 处理UUID');
                            console.log('📝 原始UUID:', uuid);
                            console.log('🔐 SHA-224结果:', processedUuid);
                        } else if (typeof sha224 !== 'undefined') {
                            processedUuid = sha224(uuid);
                            console.log('🎯 使用 sha224 处理UUID');
                            console.log('📝 原始UUID:', uuid);
                            console.log('🔐 SHA-224结果:', processedUuid);
                        } else {
                            console.warn('⚠️ SHA224函数未加载，跳过验证');
                        }
                    } catch (error) {
                        console.error('❌ SHA224处理失败:', error);
                        processedUuid = ''; // 失败时跳过验证
                    }
                }
                
                let updatedCode = snippetCodeCache;
                
                // 替换第一行的 FIXED_UUID 值
                const firstLine = "const FIXED_UUID = '';";
                const newFirstLine = \`const FIXED_UUID = '\${processedUuid}';\`;
                updatedCode = updatedCode.replace(firstLine, newFirstLine);
                
                snippetCodeElement.value = updatedCode;
            }
        }

        // 复制 Snippet 代码
        function copySnippetCode() {
            const snippetCodeElement = document.getElementById('snippetCode');
            const code = snippetCodeElement.value;
            
            // 添加点击视觉反馈
            snippetCodeElement.style.background = 'rgba(0, 255, 255, 0.1)';
            snippetCodeElement.style.borderColor = 'rgba(0, 255, 255, 0.6)';
            
            if (navigator.clipboard && window.isSecureContext) {
                navigator.clipboard.writeText(code).then(() => {
                    showCopySuccessForSnippetCodeBox();
                }).catch(err => {
                    fallbackCopyTextToClipboard(code, snippetCodeElement);
                    showCopySuccessForSnippetCodeBox();
                });
            } else {
                fallbackCopyTextToClipboard(code, snippetCodeElement);
                showCopySuccessForSnippetCodeBox();
            }
        }

        // 显示复制成功（针对 Snippet 代码框）
        function showCopySuccessForSnippetCodeBox() {
            const snippetCodeElement = document.getElementById('snippetCode');
            const button = snippetCodeElement.nextElementSibling;
            
            // 更新代码框样式
            snippetCodeElement.style.background = 'rgba(0, 255, 157, 0.15)';
            snippetCodeElement.style.borderColor = '#00ff9d';
            snippetCodeElement.style.boxShadow = '0 0 15px rgba(0, 255, 157, 0.3)';
            
            // 更新按钮
            if (button) {
                const originalText = button.textContent;
                button.textContent = '✅ 已复制!';
                button.style.background = 'rgba(0, 255, 157, 0.3)';
                button.style.borderColor = '#00ff9d';
                button.style.color = '#00ff9d';
                
                setTimeout(() => {
                    button.textContent = originalText;
                    button.style.background = 'rgba(0, 255, 255, 0.2)';
                    button.style.borderColor = 'rgba(0, 255, 255, 0.4)';
                    button.style.color = '#00ffff';
                }, 2000);
            }
            
            // 恢复代码框样式
            setTimeout(() => {
                snippetCodeElement.style.background = '#1a202c';
                snippetCodeElement.style.borderColor = 'rgba(0, 255, 255, 0.2)';
                snippetCodeElement.style.boxShadow = 'none';
            }, 2000);
        }
        
        // 显示复制成功（针对按钮）
        function showCopySuccessForButton(elementId) {
            const button = document.querySelector(\`#\${elementId} + button\`);
            if (button) {
                const originalText = button.textContent;
                button.textContent = '✅ 已复制!';
                button.style.background = 'rgba(0, 255, 157, 0.3)';
                button.style.borderColor = '#00ff9d';
                button.style.color = '#00ff9d';
                
                setTimeout(() => {
                    button.textContent = originalText;
                    button.style.background = 'rgba(0, 255, 255, 0.2)';
                    button.style.borderColor = 'rgba(0, 255, 255, 0.4)';
                    button.style.color = '#00ffff';
                }, 2000);
            }
        }
        
        // 显示复制成功（针对代码框）
        function showCopySuccessForCodeBox() {
            const workerCodeElement = document.getElementById('workerCode');
            const button = workerCodeElement.nextElementSibling;
            
            // 更新代码框样式
            workerCodeElement.style.background = 'rgba(0, 255, 157, 0.15)';
            workerCodeElement.style.borderColor = '#00ff9d';
            workerCodeElement.style.boxShadow = '0 0 15px rgba(0, 255, 157, 0.3)';
            
            // 更新按钮样式
            if (button) {
                const originalText = button.textContent;
                button.textContent = '✅ 已复制!';
                button.style.background = 'rgba(0, 255, 157, 0.3)';
                button.style.borderColor = '#00ff9d';
                button.style.color = '#00ff9d';
                
                setTimeout(() => {
                    button.textContent = originalText;
                    button.style.background = 'rgba(0, 255, 255, 0.2)';
                    button.style.borderColor = 'rgba(0, 255, 255, 0.4)';
                    button.style.color = '#00ffff';
                }, 2000);
            }
            
            // 恢复代码框原始样式
            setTimeout(() => {
                workerCodeElement.style.background = '#1a202c';
                workerCodeElement.style.borderColor = 'rgba(0, 255, 255, 0.2)';
                workerCodeElement.style.boxShadow = 'none';
            }, 2000);
        }
        
        // 显示下载成功
        function showDownloadSuccess() {
            // 可以添加一个临时的提示信息
            const notification = document.createElement('div');
            notification.textContent = '📦 开始下载 proxy_host.zip...';
            notification.style.cssText = \`
                position: fixed;
                top: 20px;
                right: 20px;
                background: rgba(0, 255, 157, 0.9);
                color: #1a202c;
                padding: 12px 20px;
                border-radius: 8px;
                font-weight: 600;
                z-index: 10000;
                box-shadow: 0 4px 15px rgba(0, 255, 157, 0.3);
            \`;
            
            document.body.appendChild(notification);
            
            setTimeout(() => {
                if (notification.parentNode) {
                    notification.parentNode.removeChild(notification);
                }
            }, 3000);
        }
        
        // 显示域名提取提示
        function showDomainExtractionNotice(originalValue, extractedDomain) {
            const notification = document.createElement('div');
            notification.innerHTML = \`
                <div style="margin-bottom: 8px;">
                    <span style="color: #ffc107; font-weight: 600;">🔧 自动优化：</span>
                </div>
                <div style="font-size: 13px; opacity: 0.9;">
                    <div>原输入：<span style="color: #ff6b6b;">\${originalValue}</span></div>
                    <div>已优化为：<span style="color: #00ff9d;">\${extractedDomain}</span></div>
                </div>
            \`;
            notification.style.cssText = \`
                position: fixed;
                top: 20px;
                right: 20px;
                background: rgba(26, 32, 44, 0.95);
                color: #e2e8f0;
                padding: 15px 20px;
                border-radius: 10px;
                font-weight: 500;
                z-index: 10000;
                box-shadow: 0 8px 25px rgba(0, 0, 0, 0.3);
                border: 1px solid rgba(255, 193, 7, 0.3);
                backdrop-filter: blur(10px);
                max-width: 300px;
                word-break: break-all;
            \`;
            
            document.body.appendChild(notification);
            
            setTimeout(() => {
                if (notification.parentNode) {
                    notification.parentNode.removeChild(notification);
                }
            }, 4000);
        }
        
        // 代理模式切换函数
        function toggleProxyMode() {
            const proxyMode = document.querySelector('input[name="proxyMode"]:checked').value;
            const proxyipGroup = document.getElementById('proxyip-group');
            const socks5Group = document.getElementById('socks5-group');
            const httpGroup = document.getElementById('http-group');
            
            // 更新单选框样式
            document.querySelectorAll('input[name="proxyMode"]').forEach(radio => {
                const radioOption = radio.closest('.radio-option');
                if (radio.checked) {
                    radioOption.classList.add('checked');
                } else {
                    radioOption.classList.remove('checked');
                }
            });
            
            // 切换显示内容
            if (proxyMode === 'socks5') {
                proxyipGroup.style.display = 'none';
                socks5Group.style.display = 'block';
                httpGroup.style.display = 'none';
            } else if (proxyMode === 'http') {
                proxyipGroup.style.display = 'none';
                socks5Group.style.display = 'none';
                httpGroup.style.display = 'block';
            } else {
                proxyipGroup.style.display = 'block';
                socks5Group.style.display = 'none';
                httpGroup.style.display = 'none';
            }
        }
        
        // IP模式切换函数
        function toggleIPMode() {
            const ipMode = document.querySelector('input[name="ipMode"]:checked').value;
            const customIpGroup = document.getElementById('custom-ip-group');
            const subscriptionGeneratorGroup = document.getElementById('subscription-generator-group');
            
            // 更新单选框样式
            document.querySelectorAll('input[name="ipMode"]').forEach(radio => {
                const radioOption = radio.closest('.radio-option');
                if (radio.checked) {
                    radioOption.classList.add('checked');
                } else {
                    radioOption.classList.remove('checked');
                }
            });
            
            // 切换显示内容
            if (ipMode === 'subscription') {
                customIpGroup.style.display = 'none';
                subscriptionGeneratorGroup.style.display = 'block';
            } else {
                customIpGroup.style.display = 'block';
                subscriptionGeneratorGroup.style.display = 'none';
            }
        }
        
        // 提取域名函数
        function extractDomain(input) {
            if (!input) return input;
            
            let cleaned = input.trim();
            
            // 如果包含协议，提取域名部分
            if (cleaned.includes('://')) {
                try {
                    const url = new URL(cleaned);
                    return url.hostname;
                } catch (error) {
                    // 如果URL解析失败，尝试手动提取
                    const match = cleaned.match(/^https?:\\/\\/([^\\/]+)/);
                    if (match) {
                        return match[1];
                    }
                }
            }
            
            // 移除路径部分（如果存在）
            if (cleaned.includes('/')) {
                cleaned = cleaned.split('/')[0];
            }
            
            // 移除查询参数和hash（如果存在）
            cleaned = cleaned.split('?')[0].split('#')[0];
            
            return cleaned;
        }
        
        // 智能处理 proxyip 格式的函数
        function processProxyIP(input) {
            // 如果输入为空，返回原值
            if (!input) return input;
            
            // 如果已经包含冒号，直接返回
            if (input.includes(':')) {
                return input;
            }
            
            // 检查是否包含 .tp 模式
            const tpMatch = input.match(/\\.tp(\\d+)\\./);
            if (tpMatch) {
                const port = tpMatch[1];
                return \`\${input}:\${port}\`;
            }
            
            // 如果都不匹配，返回原值
            return input;
        }
        
        // 智能处理 Socks5 格式的函数
        function processSocks5(input) {
            if (!input) return null;
            
            let cleaned = input.trim();
            
            // 移除各种协议前缀 - 修复转义问题
            cleaned = cleaned.replace(/^(socks5?:\\/\\/|socks:\\/\\/)/i, '');
            
            // 移除末尾的路径、fragment等 - 修复转义问题  
            cleaned = cleaned.replace(/[\\/#].*$/, '');
            
            // 验证基本格式
            // 支持格式: user:password@host:port 或 host:port
            // 修正正则表达式逻辑
            let match;
            let user, password, host, port;
            
            // 检查是否包含用户名和密码（包含@符号）
            if (cleaned.includes('@')) {
                // 格式: user:password@host:port
                const authRegex = /^([^:@]+):([^:@]+)@([^:@\\s]+):(\\d+)$/;
                match = cleaned.match(authRegex);
                if (match) {
                    [, user, password, host, port] = match;
                }
            } else {
                // 格式: host:port
                const simpleRegex = /^([^:@\\s]+):(\\d+)$/;
                match = cleaned.match(simpleRegex);
                if (match) {
                    [, host, port] = match;
                }
            }
            
            if (!match) {
                return null;
            }
            
            // 验证端口范围
            const portNum = parseInt(port);
            if (portNum < 1 || portNum > 65535) {
                return null;
            }
            
            // 构建最终格式
            if (user && password) {
                return \`\${user}:\${password}@\${host}:\${port}\`;
            } else {
                return \`\${host}:\${port}\`;
            }
        }
        
        // 页面加载完成后的初始化
        document.addEventListener('DOMContentLoaded', function() {
            console.log('页面加载完成，开始初始化...');
            
            // 加载Worker代码
            loadWorkerCode();
            
            // 加载Snippet代码
            loadSnippetCode();
            
            // 初始化 UUID 按钮样式
            updateUuidButtonStyle();
            
            // 首先加载缓存的表单数据
            loadFormData();
            
            // 加载JSON配置文件
            loadJsonConfigs();
            
            // 设置自动保存功能
            setupAutoSave();
            
            // 初始化IP模式单选框状态
            document.querySelectorAll('input[name="ipMode"]').forEach(radio => {
                const radioOption = radio.closest('.radio-option');
                if (radio.checked) {
                    radioOption.classList.add('checked');
                }
                
                // 添加事件监听
                radio.addEventListener('change', function() {
                    toggleIPMode();
                });
            });
            
            // 初始化代理模式单选框状态
            document.querySelectorAll('input[name="proxyMode"]').forEach(radio => {
                const radioOption = radio.closest('.radio-option');
                if (radio.checked) {
                    radioOption.classList.add('checked');
                }
                
                // 添加事件监听
                radio.addEventListener('change', function() {
                    toggleProxyMode();
                });
            });
            
            // 初始化源码选择下拉框状态
            const snippetSourceSelect = document.getElementById('snippetSourceSelect');
            if (snippetSourceSelect) {
                // 添加事件监听
                snippetSourceSelect.addEventListener('change', function() {
                    changeSnippetSource();
                });
            }
            
            // 执行初始切换以确保显示状态正确
            toggleIPMode();
            toggleProxyMode();
            
            // 初始化ed选项可用性检查
            checkEdOptionAvailability();
            
            // 初始化HTTP代理选项可用性检查（强制使用 snippets）
            checkHttpProxyAvailability('snippets');
            
            // 初始化复选框事件监听
            const globalSocks5Checkbox = document.getElementById('globalSocks5');
            if (globalSocks5Checkbox) {
                // 初始化状态
                const checkboxOption = globalSocks5Checkbox.closest('.checkbox-option') || globalSocks5Checkbox.closest('.checkbox-option-inline');
                if (checkboxOption && globalSocks5Checkbox.checked) {
                    checkboxOption.classList.add('checked');
                }
                
                globalSocks5Checkbox.addEventListener('change', function() {
                    console.log('复选框状态改变:', this.checked); // 调试日志
                    // 支持两种复选框样式
                    const checkboxOption = this.closest('.checkbox-option') || this.closest('.checkbox-option-inline');
                    if (checkboxOption) {
                        if (this.checked) {
                            checkboxOption.classList.add('checked');
                        } else {
                            checkboxOption.classList.remove('checked');
                        }
                    }
                });
                
                // 为label容器添加点击事件支持（备用方案）
                const checkboxLabel = globalSocks5Checkbox.closest('.checkbox-option-inline');
                if (checkboxLabel) {
                    checkboxLabel.addEventListener('click', function(e) {
                        console.log('点击了复选框容器', e.target); // 调试日志
                        // 如果点击的不是复选框本身，则手动切换复选框状态
                        if (e.target !== globalSocks5Checkbox) {
                            e.preventDefault();
                            e.stopPropagation();
                            globalSocks5Checkbox.checked = !globalSocks5Checkbox.checked;
                            globalSocks5Checkbox.dispatchEvent(new Event('change', { bubbles: true }));
                        }
                    });
                }
            }
            
            // 初始化高级参数复选框事件监听
            const enableEdCheckbox = document.getElementById('enableEd');
            if (enableEdCheckbox) {
                const checkboxOption = enableEdCheckbox.closest('.checkbox-option');
                if (checkboxOption && enableEdCheckbox.checked) {
                    checkboxOption.classList.add('checked');
                }
                
                enableEdCheckbox.addEventListener('change', function() {
                    const checkboxOption = this.closest('.checkbox-option');
                    if (checkboxOption) {
                        if (this.checked) {
                            checkboxOption.classList.add('checked');
                        } else {
                            checkboxOption.classList.remove('checked');
                        }
                    }
                });
            }
            
            const skipCertVerifyCheckbox = document.getElementById('skipCertVerify');
            if (skipCertVerifyCheckbox) {
                const checkboxOption = skipCertVerifyCheckbox.closest('.checkbox-option');
                if (checkboxOption && skipCertVerifyCheckbox.checked) {
                    checkboxOption.classList.add('checked');
                }
                
                skipCertVerifyCheckbox.addEventListener('change', function() {
                    const checkboxOption = this.closest('.checkbox-option');
                    if (checkboxOption) {
                        if (this.checked) {
                            checkboxOption.classList.add('checked');
                        } else {
                            checkboxOption.classList.remove('checked');
                        }
                    }
                });
            }
        });
    </script>
</body>
</html>`;
    return new Response(HTML, {
        headers: {
            "content-type": "text/html;charset=UTF-8",
        },
    });
}

function encodeBase64(data) {
    const binary = new TextEncoder().encode(data);
    let base64 = '';
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/';

    for (let i = 0; i < binary.length; i += 3) {
        const byte1 = binary[i];
        const byte2 = binary[i + 1] || 0;
        const byte3 = binary[i + 2] || 0;

        base64 += chars[byte1 >> 2];
        base64 += chars[((byte1 & 3) << 4) | (byte2 >> 4)];
        base64 += chars[((byte2 & 15) << 2) | (byte3 >> 6)];
        base64 += chars[byte3 & 63];
    }

    const padding = 3 - (binary.length % 3 || 3);
    return base64.slice(0, base64.length - padding) + '=='.slice(0, padding);
}

async function 解析William域名(william) {
    try {
        const response = await fetch(`https://1.1.1.1/dns-query?name=${william}&type=TXT`, { headers: { 'Accept': 'application/dns-json' } });
        if (!response.ok) return null;
        const data = await response.json();
        const txtRecords = (data.Answer || []).filter(record => record.type === 16).map(record => record.data);
        if (txtRecords.length === 0) return null;
        let txtData = txtRecords[0];
        if (txtData.startsWith('"') && txtData.endsWith('"')) txtData = txtData.slice(1, -1);
        const prefixes = txtData.replace(/\\010/g, ',').replace(/\n/g, ',').split(',').map(s => s.trim()).filter(Boolean);
        if (prefixes.length === 0) return null;
        const selectedIP = prefixes[Math.floor(Math.random() * prefixes.length)];
        let 地址 = selectedIP, 端口 = 443;
        if (selectedIP.includes('.tp')) {
            const tpMatch = selectedIP.match(/\.tp(\d+)/);
            if (tpMatch) 端口 = parseInt(tpMatch[1], 10);
            return [地址, 端口];
        }
        if (selectedIP.includes(']:')) {
            const parts = selectedIP.split(']:');
            地址 = parts[0] + ']';
            端口 = parseInt(parts[1], 10) || 端口;
        } else if (selectedIP.includes(':') && !selectedIP.startsWith('[')) {
            const colonIndex = selectedIP.lastIndexOf(':');
            地址 = selectedIP.slice(0, colonIndex);
            端口 = parseInt(selectedIP.slice(colonIndex + 1), 10) || 端口;
        }
        if (地址.includes(':')) {
            return `${地址.replace(/^\[|]$/g, '').replace(/:/g, '-')}.tp${端口}.ip.090227.xyz`;
        } else {
            const parts = 地址.split('.').map(part => {
                const hex = parseInt(part, 10).toString(16);
                return hex.length === 1 ? '0' + hex : hex;
            });
            const nip = parts.join('');
            return `${nip}.tp${端口}.ip.090227.xyz`;
        }
    } catch (error) {
        console.error('解析ProxyIP失败:', error);
        return null;
    }
}
