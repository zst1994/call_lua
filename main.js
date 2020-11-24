"ui";
var color = "#eeeeee";
var STORAGE = storages.create("拇指客");

ui.layout(
    <drawer>
        <vertical >
            <appbar>
                <toolbar id="toolbar" title="拇指脚本" />
                {/* <tabs id="tabs" /> */}
            </appbar>
            <frame w="*" h="*">
                <vertical w="*" h="*" background="#f2f2f2">

                    <card cardBackgroundColor="#ffffff" alpha="0.95" w="*" h="auto" margin="5 5" cardCornerRadius="5dp" cardEleavation="1dp" graviy="center">
                        <vertical padding="8 8 8 8">
                            <Switch id="autoService" text="无障碍服务" checked="{{auto.service != null}}" textSize="15sp" />
                        </vertical>

                    </card >

                    <card cardBackgroundColor="#ffffff" alpha="0.95" w="*" h="auto" margin="5 5" cardCornerRadius="5dp" cardEleavation="1dp" graviy="center">
                        <vertical >
                            <linear >
                                <text w="90sp" gravity="center" color="#111111" size="16" padding="0 8 8 8" textSize="15sp">脚本卡密:</text>
                                <input id="kami" w="*" padding="8 8 8 8" textSize="15sp" />
                            </linear>
                            <linear>
                                <text w="90sp" gravity="center" color="#111111" size="16" padding="0 8 8 8" textSize="15sp">攒攒账号:</text>
                                <input id="zzuser" w="*" padding="8 8 8 8" textSize="15sp" />
                            </linear>
                            <linear>
                                <text w="90sp" gravity="center" color="#111111" size="16" padding="0 8 8 8" textSize="15sp" >攒攒密码:</text>
                                <input id="zzpwd" w="*" password="true" textSize="15sp" />
                            </linear>
                            <linear>
                                <text w="90sp" gravity="center" color="#111111" size="16" padding="0 8 8 8" textSize="15sp" >抖音链接:</text>
                                <input id="dyurl" w="*" inputType="textLongMessage" hint="在抖音，记录美好生活！ https://v.douyin.com/tUvx1o/" textSize="15sp" />
                            </linear>
                        </vertical>
                    </card>

                    <card cardBackgroundColor="#ffffff" alpha="0.95" w="*" h="auto" margin="8 8" cardCornerRadius="5dp" cardEleavation="1dp" graviy="center">
                        <vertical>
                            <linear padding="8 8 8 0" >
                                <text text="抖音：" />
                                <input id="rw_dy" w="45" inputType="textLongMessage" textSize="15sp" />
                                <checkbox id="dygz" text="关注" textSize="14sp" />
                                <checkbox id="dypl" text="评论" textSize="14sp" />
                                <checkbox id="dytj" text="特价点赞" textSize="14sp" />
                            </linear>
                            {/* 分割线填充 */}
                            <vertical id="fill_line" w="*" h="1" bg="{{color}}"></vertical>
                            <linear padding="8 0 8 0" >
                                <text text="快手：" />
                                <input id="rw_ks" w="45" inputType="textLongMessage" textSize="15sp" />
                                <checkbox id="ksgz" text="关注" textSize="14sp" />
                                {/* <checkbox id="cb5" text="评论" textSize="14sp" /> */}
                            </linear>
                            {/* 分割线填充 */}
                            <vertical id="fill_line" w="*" h="1" bg="{{color}}"></vertical>
                            <linear padding="8 0 8 0" >
                                <text text="红书：" />
                                <input id="rw_xhs" w="45" inputType="textLongMessage" textSize="15sp" />
                                <checkbox id="cb6" text="关注" textSize="14sp" />
                                <checkbox id="cb7" text="评论" textSize="14sp" />
                                <checkbox id="cb8" text="收藏" textSize="14sp" />
                            </linear>
                            {/* 分割线填充 */}
                            <vertical id="fill_line" w="*" h="1" bg="{{color}}"></vertical>
                            <linear padding="8 0 8 0" >
                                <text text="火山：" />
                                <input id="rw_hs" w="45" inputType="textLongMessage" textSize="15sp" />
                                <checkbox id="hs_dz" text="点赞" textSize="14sp" />
                                <checkbox id="hs_gz" text="关注" textSize="14sp" />
                                <checkbox id="hs_pl" text="评论" textSize="14sp" />
                                <checkbox id="hs_zf" text="转发" textSize="14sp" />
                            </linear>

                        </vertical>
                    </card>




                </vertical>
                <card layout_gravity="bottom" cardBackgroundColor="#ffffff" alpha="0.95" w="*" h="auto" margin="5 5" cardCornerRadius="5dp" cardEleavation="1dp" graviy="center">
                    <vertical>
                        <linear padding="8 0 8 0" >
                            <checkbox id="dy" text="抖音" textSize="14sp" />
                            <checkbox id="ks" text="快手" textSize="14sp" />
                            <checkbox id="xhs" text="小红书" textSize="14sp" />
                            <checkbox id="hs" text="火山" textSize="14sp" />
                        </linear>
                        <linear w="*" >
                            <button id="start" text="开始运行" w="*" h="50sp" layout_gravity="bottom" />
                        </linear>
                    </vertical>
                </card>
            </frame>
        </vertical>
    </drawer>
);
//让工具栏右上角可以打开侧拉菜单
activity.setSupportActionBar(ui.toolbar);
//创建选项菜单(右上角)
ui.emitter.on("create_options_menu", menu => {
    menu.add("设置");
    menu.add("日志");
    menu.add("退出");
});
//监听选项菜单点击
ui.emitter.on("options_item_selected", (e, item) => {
    switch (item.getTitle()) {
        case "设置":
            app.startActivity("settings");
            break;
        case "日志":
            app.startActivity("console");
            break;
        case "退出":
            events.removeAllListeners();
            threads.shutDownAll();  //停止所有子线程
            // if (heartBeat) clearInterval(heartBeat);
            ui.finish();
            exit();
            break;
    }
    e.consumed = true;
});
//按键监听
events.observeKey();
events.onKeyDown("volume_down", function (event) {
    toastLog("停止运行");
    console.hide();
    exit();
});
//无障碍服务
ui.autoService.on("check", function (checked) {
    if (checked && auto.service == null) {
        app.startActivity({
            action: "android.settings.ACCESSIBILITY_SETTINGS"
        });
    }
    if (!checked && auto.service != null) {
        auto.service.disableSelf();
    }
});
ui.emitter.on("resume", function () {
    ui.autoService.checked = auto.service != null;
});

ui.start.on("click", function () {
    if (auto.service == null) {
        toast("请先开启无障碍服务！");
        return;
    }

    //保存复选框
    //抖音
    gz = ui.dygz.isChecked();
    if (gz) {
        STORAGE.put("dygz", "true");
    } else {
        STORAGE.put("dygz", "false");
    }
    pl = ui.dypl.isChecked();
    if (pl) {
        STORAGE.put("dypl", "true");
    } else {
        STORAGE.put("dypl", "false");
    }
    tj = ui.dytj.isChecked();
    if (tj) {
        STORAGE.put("dytj", "true");
    } else {
        STORAGE.put("dytj", "false");
    }
    //小红书
    //快手
    ksgz = ui.ksgz.isChecked();
    if (ksgz) {
        STORAGE.put("ksgz", "true");
    } else {
        STORAGE.put("ksgz", "false");
    }
    //火山
    hs_dz = ui.hs_dz.isChecked();
    hs_gz = ui.hs_gz.isChecked();
    hs_pl = ui.hs_pl.isChecked();
    hs_zf = ui.hs_zf.isChecked();

    if (hs_dz) {
        STORAGE.put("hs_dz", "true");
    } else {
        STORAGE.put("hs_dz", "false");
    }

    if (hs_gz) {
        STORAGE.put("hs_gz", "true");
    } else {
        STORAGE.put("hs_gz", "false");
    }
    if (hs_pl) {
        STORAGE.put("hs_pl", "true");
    } else {
        STORAGE.put("hs_pl", "false");
    }
    if (hs_zf) {
        STORAGE.put("hs_zf", "true");
    } else {
        STORAGE.put("hs_zf", "false");
    }

    //任务类型
    dy = ui.dy.isChecked();
    if (dy) {
        STORAGE.put("dy", "true");
    } else {
        STORAGE.put("dy", "false");
    }
    ks = ui.ks.isChecked();
    if (ks) {
        STORAGE.put("ks", "true");
    } else {
        STORAGE.put("ks", "false");
    }
    xhs = ui.xhs.isChecked();
    if (xhs) {
        STORAGE.put("xhs", "true");
    } else {
        STORAGE.put("xhs", "false");
    }
    hs = ui.hs.isChecked();
    if (hs) {
        STORAGE.put("hs", "true");
    } else {
        STORAGE.put("hs", "false");
    }
    //输入框配置保存
    kami = ui.kami.text();
    zzuser = ui.zzuser.text();
    zzpwd = ui.zzpwd.text();
    dy_url = ui.dyurl.text();
    rw_dy = ui.rw_dy.text();
    rw_ks = ui.rw_ks.text();
    rw_xhs = ui.rw_xhs.text();
    rw_hs = ui.rw_hs.text();
    STORAGE.put("kami", kami);
    STORAGE.put("zzuser", zzuser);
    STORAGE.put("zzpwd", zzpwd);
    STORAGE.put("dy_url", dy_url);
    STORAGE.put("rw_dy", rw_dy);
    STORAGE.put("rw_ks", rw_ks);
    STORAGE.put("rw_xhs", rw_xhs);
    STORAGE.put("rw_hs", rw_hs);

    截图路径();
    work = threads.start(wlyz);
});

const PJYSDK = (function () {
    function PJYSDK(app_key, app_secret) {
        http.__okhttp__.setMaxRetries(0);

        this.event = events.emitter();

        this.debug = true;
        this._lib_version = "v1.01";
        this._protocol = "https";
        this._host = "api.paojiaoyun.com";
        this._device_id = this.getDeviceID();

        this._app_key = app_key;  // AppKey，在开发者后台获取
        this._app_secret = app_secret;  // AppScret，在开发者后获取

        this._card = null;
        this._username = null;
        this._password = null;
        this._token = null;

        this.is_trial = false;  // 是否是试用用户
        this.login_result = {
            "card_type": "",
            "expires": "",
            "expires_ts": 0,
            "config": "",
        };

        this._auto_heartbeat = true;  // 是否自动开启心跳任务
        this._heartbeat_gap = 60 * 1000; // 默认60秒
        this._heartbeat_task = null;
        this._heartbeat_ret = { "code": -9, "message": "还未开始验证" };

        this._prev_nonce = null;
    }
    PJYSDK.prototype.SetCard = function (card) {
        this._card = card;
    }
    PJYSDK.prototype.SetUser = function (username, password) {
        this._username = username;
        this._password = password;
    }
    PJYSDK.prototype.getDeviceID = function () {
        let id = device.serial;
        if (id == "") {
            id = device.getIMEI();
        }
        return id;
    }
    PJYSDK.prototype.MD5 = function (str) {
        try {
            let digest = java.security.MessageDigest.getInstance("md5");
            let result = digest.digest(new java.lang.String(str).getBytes("UTF-8"));
            let buffer = new java.lang.StringBuffer();
            for (let index = 0; index < result.length; index++) {
                let b = result[index];
                let number = b & 0xff;
                let str = java.lang.Integer.toHexString(number);
                if (str.length == 1) {
                    buffer.append("0");
                }
                buffer.append(str);
            }
            return buffer.toString();
        } catch (error) {
            alert(error);
            return "";
        }
    }
    PJYSDK.prototype.getTimestamp = function () {
        try {
            let res = http.get("http://api.m.taobao.com/rest/api3.do?api=mtop.common.getTimestamp");
            let data = res.body.json();
            return Math.floor(data["data"]["t"] / 1000);
        } catch (error) {
            return Math.floor(new Date().getTime() / 1000);
        }
    }
    PJYSDK.prototype.genNonce = function () {
        const ascii_str = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
        let tmp = '';
        for (let i = 0; i < 20; i++) {
            tmp += ascii_str.charAt(Math.round(Math.random() * ascii_str.length));
        }
        return tmp;
    }
    PJYSDK.prototype.joinParams = function (params) {
        let ps = [];
        for (let k in params) {
            ps.push(k + "=" + params[k])
        }
        ps.sort()
        return ps.join("&")
    }
    PJYSDK.prototype.CheckRespSign = function (resp) {
        let ps = "";
        if (resp["result"]) {
            ps = this.joinParams(resp["result"]);
        }

        let s = resp["code"] + resp["message"] + ps + resp["nonce"] + this._app_secret;
        let sign = this.MD5(s);
        if (sign === resp["sign"]) {
            if (this._prev_nonce === null) {
                this._prev_nonce = resp["nonce"];
                return { "code": 0, "message": "OK" };
            } else {
                if (this._prev_nonce === resp["nonce"]) {
                    return { "code": -98, "message": "轻点，疼~" };
                } else {
                    return { "code": 0, "message": "OK" };
                }
            }
        }
        return { "code": -99, "message": "轻点，疼~" };
    }
    PJYSDK.prototype._debug = function (path, params, result) {
        if (this.debug) {
            log("\n" + path, "\nparams:", params, "\nresult:", result);
        }
    }
    PJYSDK.prototype.Request = function (method, path, params) {
        // 构建公共参数
        params["app_key"] = this._app_key;
        params["nonce"] = this.genNonce();
        params["timestamp"] = this.getTimestamp();

        method = method.toUpperCase();
        let url = this._protocol + "://" + this._host + path
        let max_retries = 5;
        let retries_count = 0;

        let ps = this.joinParams(params);
        let s = method + this._host + path + ps + this._app_secret;

        let sign = this.MD5(s);
        params["sign"] = sign;

        let data = { "code": -1, "message": "连接服务器失败" };
        do {
            retries_count++;

            let resp, body;
            try {
                if (method === "GET") {
                    resp = http.get(url + "?" + ps + "&sign=" + sign);
                } else {  // POST
                    resp = http.post(url, params);
                }
                body = resp.body.string();
                data = JSON.parse(body);
                this._debug(method + '-' + path + ':', params, data);

                let crs = this.CheckRespSign(data);
                if (crs.code !== 0) {
                    return crs;
                } else {
                    return data;
                }
            } catch (error) {
                log("[*] request error: ", error);
                this._debug(method + '-' + path + ':', params, body)
                sleep(1000);
            }
        } while (retries_count < max_retries);

        return data;
    }
    /* 通用 */
    PJYSDK.prototype.GetHeartbeatResult = function () {
        return this._heartbeat_ret;
    }
    PJYSDK.prototype.GetTimeRemaining = function () {
        let g = this.login_result.expires_ts - this.getTimestamp();
        if (g < 0) {
            return 0;
        }
        return g;
    }
    /* 卡密相关 */
    PJYSDK.prototype.CardLogin = function () {  // 卡密登录
        if (!this._card) {
            return { "code": -4, "message": "请先设置卡密" };
        }
        if (this._token) {
            return { "code": -3, "message": "请先退出登录" };
        }
        let method = "POST";
        let path = "/v1/card/login";
        let data = { "card": this._card, "device_id": this._device_id };
        let ret = this.Request(method, path, data);
        if (ret.code == 0) {
            this._token = ret.result.token;
            this.login_result = ret.result;
            if (this._auto_heartbeat) {
                this._startCardHeartheat();
            }
        }
        return ret;
    }
    PJYSDK.prototype.CardHeartbeat = function () {  // 卡密心跳，默认会自动调用
        if (!this._token) {
            return { "code": -2, "message": "请在卡密登录成功后调用" };
        }
        let method = "POST";
        let path = "/v1/card/heartbeat";
        let data = { "card": this._card, "token": this._token };
        let ret = this.Request(method, path, data);
        if (ret.code == 0) {
            this.login_result.expires = ret.result.expires;
            this.login_result.expires_ts = ret.result.expires_ts;
        }
        return ret;
    }
    PJYSDK.prototype._startCardHeartheat = function () {  // 开启卡密心跳任务
        if (this._heartbeat_task) {
            this._heartbeat_task.interrupt();
            this._heartbeat_task = null;
        }
        this._heartbeat_task = threads.start(function () {
            setInterval(function () { }, 10000);
        });
        this._heartbeat_ret = this.CardHeartbeat();

        this._heartbeat_task.setInterval((self) => {
            self._heartbeat_ret = self.CardHeartbeat();
            if (self._heartbeat_ret.code != 0) {
                self.event.emit("heartbeat_failed", self._heartbeat_ret);
            }
        }, this._heartbeat_gap, this);

        this._heartbeat_task.setInterval((self) => {
            if (self.GetTimeRemaining() == 0) {
                self.event.emit("heartbeat_failed", { "code": 10210, "message": "卡密已过期！" });
            }
        }, 1000, this);
    }
    PJYSDK.prototype.CardLogout = function () {  // 卡密退出登录
        this._heartbeat_ret = { "code": -9, "message": "还未开始验证" };
        if (this._heartbeat_task) { // 结束心跳任务
            this._heartbeat_task.interrupt();
            this._heartbeat_task = null;
        }
        if (!this._token) {
            return { "code": 0, "message": "OK" };
        }
        let method = "POST";
        let path = "/v1/card/logout";
        let data = { "card": this._card, "token": this._token };
        let ret = this.Request(method, path, data);
        // 清理
        this._token = null;
        this.login_result = {
            "card_type": "",
            "expires": "",
            "expires_ts": 0,
            "config": "",
        };
        return ret;
    }
    PJYSDK.prototype.CardUnbindDevice = function () { // 卡密解绑设备，需开发者后台配置
        if (!this._token) {
            return { "code": -2, "message": "请在卡密登录成功后调用" };
        }
        let method = "POST";
        let path = "/v1/card/unbind_device";
        let data = { "card": this._card, "device_id": this._device_id, "token": this._token };
        return this.Request(method, path, data);
    }
    PJYSDK.prototype.SetCardUnbindPassword = function (password) { // 自定义设置解绑密码
        if (!this._token) {
            return { "code": -2, "message": "请在卡密登录成功后调用" };
        }
        let method = "POST";
        let path = "/v1/card/unbind_password";
        let data = { "card": this._card, "password": password, "token": this._token };
        return this.Request(method, path, data);
    }
    PJYSDK.prototype.CardUnbindDeviceByPassword = function (password) { // 用户通过解绑密码解绑设备
        let method = "POST";
        let path = "/v1/card/unbind_device/by_password";
        let data = { "card": this._card, "password": password };
        return this.Request(method, path, data);
    }
    /* 用户相关 */
    PJYSDK.prototype.UserRegister = function (username, password, card) {  // 用户注册（通过卡密）
        let method = "POST";
        let path = "/v1/user/register";
        let data = { "username": username, "password": password, "card": card, "device_id": this._device_id };
        return this.Request(method, path, data);
    }
    PJYSDK.prototype.UserLogin = function () {  // 用户账号登录
        if (!this._username || !this._password) {
            return { "code": -4, "message": "请先设置用户账号密码" };
        }
        if (this._token) {
            return { "code": -3, "message": "请先退出登录" };
        }
        let method = "POST";
        let path = "/v1/user/login";
        let data = { "username": this._username, "password": this._password, "device_id": this._device_id };
        let ret = this.Request(method, path, data);
        if (ret.code == 0) {
            this._token = ret.result.token;
            this.login_result = ret.result;
            if (this._auto_heartbeat) {
                this._startUserHeartheat();
            }
        }
        return ret;
    }
    PJYSDK.prototype.UserHeartbeat = function () {  // 用户心跳，默认会自动开启
        if (!this._token) {
            return { "code": -2, "message": "请在用户登录成功后调用" };
        }
        let method = "POST";
        let path = "/v1/user/heartbeat";
        let data = { "username": this._username, "token": this._token };
        let ret = this.Request(method, path, data);
        if (ret.code == 0) {
            this.login_result.expires = ret.result.expires;
            this.login_result.expires_ts = ret.result.expires_ts;
        }
        return ret;
    }
    PJYSDK.prototype._startUserHeartheat = function () {  // 开启用户心跳任务
        if (this._heartbeat_task) {
            this._heartbeat_task.interrupt();
            this._heartbeat_task = null;
        }
        this._heartbeat_task = threads.start(function () {
            setInterval(function () { }, 10000);
        });
        this._heartbeat_ret = this.UserHeartbeat();

        this._heartbeat_task.setInterval((self) => {
            self._heartbeat_ret = self.UserHeartbeat();
            if (self._heartbeat_ret.code != 0) {
                self.event.emit("heartbeat_failed", self._heartbeat_ret);
            }
        }, this._heartbeat_gap, this);

        this._heartbeat_task.setInterval((self) => {
            if (self.GetTimeRemaining() == 0) {
                self.event.emit("heartbeat_failed", { "code": 10250, "message": "用户已到期！" });
            }
        }, 1000, this);
    }
    PJYSDK.prototype.UserLogout = function () {  // 用户退出登录
        this._heartbeat_ret = { "code": -9, "message": "还未开始验证" };
        if (this._heartbeat_task) { // 结束心跳任务
            this._heartbeat_task.interrupt();
            this._heartbeat_task = null;
        }
        if (!this._token) {
            return { "code": 0, "message": "OK" };
        }
        let method = "POST";
        let path = "/v1/user/logout";
        let data = { "username": this._username, "token": this._token };
        let ret = this.Request(method, path, data);
        // 清理
        this._token = null;
        this.login_result = {
            "card_type": "",
            "expires": "",
            "expires_ts": 0,
            "config": "",
        };
        return ret;
    }
    PJYSDK.prototype.UserChangePassword = function (username, password, new_password) {  // 用户修改密码
        let method = "POST";
        let path = "/v1/user/password";
        let data = { "username": username, "password": password, "new_password": new_password };
        return this.Request(method, path, data);
    }
    PJYSDK.prototype.UserRecharge = function (username, card) { // 用户通过卡密充值
        let method = "POST";
        let path = "/v1/user/recharge";
        let data = { "username": username, "card": card };
        return this.Request(method, path, data);
    }
    PJYSDK.prototype.UserUnbindDevice = function () { // 用户解绑设备，需开发者后台配置
        if (!this._token) {
            return { "code": -2, "message": "请在用户登录成功后调用" };
        }
        let method = "POST";
        let path = "/v1/user/unbind_device";
        let data = { "username": this._username, "device_id": this._device_id, "token": this._token };
        return this.Request(method, path, data);
    }
    /* 配置相关 */
    PJYSDK.prototype.GetCardConfig = function () { // 获取卡密配置
        let method = "GET";
        let path = "/v1/card/config";
        let data = { "card": this._card };
        return this.Request(method, path, data);
    }
    PJYSDK.prototype.UpdateCardConfig = function (config) { // 更新卡密配置
        let method = "POST";
        let path = "/v1/card/config";
        let data = { "card": this._card, "config": config };
        return this.Request(method, path, data);
    }
    PJYSDK.prototype.GetUserConfig = function () { // 获取用户配置
        let method = "GET";
        let path = "/v1/user/config";
        let data = { "user": this._username };
        return this.Request(method, path, data);
    }
    PJYSDK.prototype.UpdateUserConfig = function (config) { // 更新用户配置
        let method = "POST";
        let path = "/v1/user/config";
        let data = { "username": this._username, "config": config };
        return this.Request(method, path, data);
    }
    /* 软件相关 */
    PJYSDK.prototype.GetSoftwareConfig = function () { // 获取软件配置
        let method = "GET";
        let path = "/v1/software/config";
        return this.Request(method, path, {});
    }
    PJYSDK.prototype.GetSoftwareNotice = function () { // 获取软件通知
        let method = "GET";
        let path = "/v1/software/notice";
        return this.Request(method, path, {});
    }
    PJYSDK.prototype.GetSoftwareLatestVersion = function (current_ver) { // 获取软件最新版本
        let method = "GET";
        let path = "/v1/software/latest_ver";
        let data = { "version": current_ver };
        return this.Request(method, path, data);
    }
    /* 试用功能 */
    PJYSDK.prototype.TrialLogin = function () {  // 试用登录
        let method = "POST";
        let path = "/v1/trial/login";
        let data = { "device_id": this._device_id };
        let ret = this.Request(method, path, data);
        if (ret.code == 0) {
            this.is_trial = true;
            this.login_result = ret.result;
            if (this._auto_heartbeat) {
                this._startTrialHeartheat();
            }
        }
        return ret;
    }
    PJYSDK.prototype.TrialHeartbeat = function () {  // 试用心跳，默认会自动调用
        let method = "POST";
        let path = "/v1/trial/heartbeat";
        let data = { "device_id": this._device_id };
        let ret = this.Request(method, path, data);
        if (ret.code == 0) {
            this.login_result.expires = ret.result.expires;
            this.login_result.expires_ts = ret.result.expires_ts;
        }
        return ret;
    }
    PJYSDK.prototype._startTrialHeartheat = function () {  // 开启试用心跳任务
        if (this._heartbeat_task) {
            this._heartbeat_task.interrupt();
            this._heartbeat_task = null;
        }
        this._heartbeat_task = threads.start(function () {
            setInterval(function () { }, 10000);
        });
        this._heartbeat_ret = this.TrialHeartbeat();

        this._heartbeat_task.setInterval((self) => {
            self._heartbeat_ret = self.CardHeartbeat();
            if (self._heartbeat_ret.code != 0) {
                self.event.emit("heartbeat_failed", self._heartbeat_ret);
            }
        }, this._heartbeat_gap, this);

        this._heartbeat_task.setInterval((self) => {
            if (self.GetTimeRemaining() == 0) {
                self.event.emit("heartbeat_failed", { "code": 10407, "message": "试用已到期！" });
            }
        }, 1000, this);
    }
    PJYSDK.prototype.TrialLogout = function () {  // 试用退出登录，没有http请求，只是清理本地记录
        this.is_trial = false;
        this._heartbeat_ret = { "code": -9, "message": "还未开始验证" };
        if (this._heartbeat_task) { // 结束心跳任务
            this._heartbeat_task.interrupt();
            this._heartbeat_task = null;
        }
        // 清理
        this._token = null;
        this.login_result = {
            "card_type": "",
            "expires": "",
            "expires_ts": 0,
            "config": "",
        };
        return { "code": 0, "message": "OK" };;
    }
    /* 高级功能 */
    PJYSDK.prototype.GetRemoteVar = function (key) { // 获取远程变量
        let method = "GET";
        let path = "/v1/af/remote_var";
        let data = { "key": key };
        return this.Request(method, path, data);
    }
    PJYSDK.prototype.GetRemoteData = function (key) { // 获取远程数据
        let method = "GET";
        let path = "/v1/af/remote_data";
        let data = { "key": key };
        return this.Request(method, path, data);
    }
    PJYSDK.prototype.CreateRemoteData = function (key, value) { // 创建远程数据
        let method = "POST";
        let path = "/v1/af/remote_data";
        let data = { "action": "create", "key": key, "value": value };
        return this.Request(method, path, data);
    }
    PJYSDK.prototype.UpdateRemoteData = function (key, value) { // 修改远程数据
        let method = "POST";
        let path = "/v1/af/remote_data";
        let data = { "action": "update", "key": key, "value": value };
        return this.Request(method, path, data);
    }
    PJYSDK.prototype.DeleteRemoteData = function (key, value) { // 删除远程数据
        let method = "POST";
        let path = "/v1/af/remote_data";
        let data = { "action": "delete", "key": key };
        return this.Request(method, path, data);
    }
    PJYSDK.prototype.CallRemoteFunc = function (func_name, params) { // 执行远程函数
        let method = "POST";
        let path = "/v1/af/call_remote_func";
        let ps = JSON.stringify(params);
        let data = { "func_name": func_name, "params": ps };
        let ret = this.Request(method, path, data);
        if (ret.code == 0 && ret.result.return) {
            ret.result = JSON.parse(ret.result.return);
        }
        return ret;
    }
    return PJYSDK;
})();

var 软件更新 = threads.start(function () {
    pjysdk = new PJYSDK("", "");
    pjysdk.debug = false;
    //获取软件版本号 
    var muzhiver = app.versionCode.toString();
    //获取软件最新版配置
    var pjysoft = pjysdk.GetSoftwareLatestVersion(muzhiver);
    var versions = pjysoft.code;
    //判断是否有新版本
    if (versions == 0) {
        //获取软件公告
        var notice = pjysoft.result.notice;
        //获取软件下载地址
        var down = pjysoft.result.url;
        var releaseNotes = notice;
        dialogs.build({
            title: "发现新版本",
            content: releaseNotes,
            positive: "到浏览器下载",
            negative: "取消",
        })
            .on("positive", () => {
                app.openUrl(down);
            })
            .show();
    }


})

function wlyz() {
    console.show();
    pjysdk.SetCard(ui.kami.getText());
    //网络验证
    let login_ret = pjysdk.CardLogin();
    if (login_ret.code != 0) {
        console.error(login_ret.message);
        pjysdk.CardLogout();
    }

    if (login_ret.code == 0) {
        // 获取心跳结果  和  获取剩余时间， 在你代码的关键逻辑入口判断
        if (pjysdk.GetHeartbeatResult().code == 0 && pjysdk.GetTimeRemaining() > 0) {
            /* 这里是你的业务代码 */
            let expires = login_ret.result.expires;
            console.info("脚本到期时间：" + expires);

            // 主线程
            threads.start(main);



        } else if (pjysdk.GetHeartbeatResult().code != 0) {
            console.error(pjysdk.GetHeartbeatResult().message);  // 如果心跳请求响应失败，提示信息
            pjysdk.CardLogout();
        } else {
            console.error("卡密已过期！");
        }
    }
}
//主程序
function main() {
    if (!requestScreenCapture()) {
        toast("请求截图失败");
        exit();
    }
    setScreenMetrics(1080, 1920);
    //登陆攒攒
    token = login(ui.zzuser.getText(), ui.zzpwd.getText());

    //判读任务类型
    if (dy) {
        //启动抖音
        app.launchApp("抖音短视频");
        console.log("抖音启动中...")
        sleep(8000);
        console.info("开始执行抖音任务");
        var d = 0;
        while (d < 2) {
            d++;
            //自动签到
            if (签到状态()) {
                抖音任务();
            }
            else {
                console.hide();
                console.log("每日签到");
                sign_img();
                sleep(1000);
                dy_点击我();
                sleep(3000);
                截图("/storage/emulated/0/Pictures/" + sign_imgname);
                console.show();
                签到提交();
                back();
                sleep(2000);
            }
        }
    } else if (ks) {
        ks_主循环();
    } else if (xhs) {
        console.info("小红书任务 正在开发。。。");
    } else if (hs) {
        console.log("开始执行火山任务");
        hs_主循环();
    }

}
//主循环
function 抖音任务() {


    if (gz && pl && tj) {
        q = 0;
        g = 0;
        log("任务类型：全部任务")
        while (today_count <= rw_dy) {
            var yhs = random(3, 8);
            sleep(5000);
            if (获取任务(true, 7)) {
                shot_img();
                任务判断(rwtype);
                养号(yhs);
            }
        }
    }
    else if (gz && tj) {
        log("任务类型：点赞关注特价")
        q = 0;
        g = 0;
        while (today_count <= rw_dy) {
            sleep(5000);
            if (获取任务(true, 3)) {
                shot_img();
                任务判断(rwtype);
            }
        }
    }
    else if (pl && tj) {
        q = 0;
        g = 0;
        log("任务类型：点赞评论特价")
        while (today_count <= rw_dy) {
            sleep(5000);
            if (获取任务(true, 5)) {
                shot_img();
                任务判断(rwtype);
            }
        }
    } else if (gz && pl) {
        q = 0;
        g = 0;
        log("任务类型：关注评论")
        while (today_count <= rw_dy) {
            sleep(5000);
            if (获取任务(true, 5)) {
                shot_img();
                任务判断(rwtype);
            }
        }
    }
    else if (pl) {
        q = 0;
        g = 0;
        log("任务类型：点赞评论");
        while (today_count <= rw_dy) {
            sleep(5000);
            if (获取任务(false, 5)) {
                shot_img();
                任务判断(rwtype);
            }
        }
    }
    else if (tj) {
        log("任务类型：点赞特价");
        q = 0;
        while (today_count <= rw_dy) {
            sleep(5000);
            if (获取任务(true, 1)) {
                shot_img();
                任务判断(rwtype);
                养号(random(1,3))
            }
        }
    } else if (gz) {
        log("任务类型：点赞关注")
        q = 0;
        g = 0;
        while (today_count <= rw_dy) {
            sleep(5000);
            if (获取任务(false, 3)) {
                shot_img();
                任务判断(rwtype);
            }
        }
    } else {
        log("任务类型：点赞")
        q = 0;
        g = 0;
        while (today_count <= rw_dy) {
            sleep(5000);
            if (获取任务(false, 1)) {
                shot_img();
                任务判断(rwtype);
            }
        }
    }
}
//账号登录
function login(username, pwd) {
    var password = getMd5(pwd + "Uk&s23^ruk@");

    var res = http.post("http://zcore.zqzan.com/app/account/login", {
        "username": username,
        "loginpw": password
    })
    if (res.statusCode !== 200) { return false; }
    var loginData = res.body.json();
    var token = loginData.data.token;
    if (loginData.code == 0) {
        console.log("攒攒登录成功");
        return token;
    }
    else if (loginData.code > 0) {
        console.log("账号或密码错误");
        console.log("停止运行")
        exit();
    }
    else { console.log("登录失败") }


}
//签到状态
function 签到状态() {
    var res = http.get("http://zcore.zqzan.com/app/douyin/my/info", { headers: { "Token": token } });
    if (res.statusCode !== 200) { return false; };
    var obj = res.body.json();
    var is_signed = obj.data.is_signed;
    today_count = obj.data.today_count;
    return is_signed;
}
//检测完成任务数
function 已完成() {
    try {
        var res = http.get("http://zcore.zqzan.com/app/douyin/my/info", { headers: { "Token": token } });
        if (res.statusCode !== 200) { return false; };
        var obj = res.body.json();
        today_count = obj.data.today_count;
        return today_count;
    } catch (err) {
        console.error("获取已完成任务请求错误");
    }

}
//获取签到参数
function sign_img() {
    var res = http.post("http://zcore.zqzan.com/app/oss/sign_img", {}, { headers: { "Token": token } });
    sign_img = res.body.json();
    sign_key = sign_img.data.dir + "/" + sign_img.data.prefix + sign_img.data.expire + ".png";
    sign_imgname = sign_img.data.prefix + sign_img.data.expire + ".png";
    sign_imgpath = "/storage/emulated/0/Pictures/" + sign_imgname;
}
//签到上传图片
function 签到提交() {
    var res = http.postMultipart("https://zqzan.oss-cn-shanghai.aliyuncs.com/", {
        key: sign_key,
        policy: sign_img["data"]["policy"],
        OSSAccessKeyId: sign_img["data"]["accessid"],
        signature: sign_img["data"]["signature"],
        success_action_status: "200",
        file: open(sign_imgpath)
    })
    if (res.statusCode !== 200) { return false; };
    var dosign = http.post("http://zcore.zqzan.com/app/douyin/do/sign", {
        "img_url": "https://zqzan.oss-cn-shanghai.aliyuncs.com/sign/" + sign_key + "@!fwidth"
    }, {
        headers: {
            "Token": token
        }
    })
    var tj = dosign.body.json();
    if (tj.msg = "操作成功") { console.log("签到成功"); }
}
//获取任务
function 获取任务(htj, num) {
    try {
        var pull = "http://zcore.zqzan.com/app/douyin/pull/one"
        var res = http.post(pull, {
            "b_discount": htj,
            "access": num,
            "exam_status": 0
        }, {
            "headers": {
                "Token": token,
            }
        });
        if (res.statusCode !== 200) { return false; }
        var obj = res.body.json();
        // log(obj);
        dyinId = obj.data.aweme_id;
        dy_anchor_id = obj.data.anchor_id;
        rwtype = obj.data.type;
        doit_id = obj.data.id;
        if (obj.code == 0) {
            return true;
        }
        else if (obj.code > 0) {
            console.log("没有任务，已完成" + 已完成() + "次任务");
        }
        else {
            return false;
        }
    }
    catch (err) {
        console.error("获取任务失败");
    }
}
//判断任务
function 任务判断(type) {
    var url = ui.dyurl.text();
    var dy_url = url.slice(12);
    // var dy_dianzan = dy_renwushu(dy_url);
    switch (type) {
        case 1:
            //特价点赞任务            
            console.info("获取到点赞任务；");
            //任务前检测点赞数
            // qxh = dy_renwushu(dy_url, 1);
            // console.log("任务前喜欢" + qxh);
            抖音跳转(dyinId);
            sleep(5000);
            if (判断黑屏()) {
                sleep(random(5000, 15000));
                console.hide();
                点赞(576, 1100, -200, 200, 2);
                sleep(2000);
                截图("/storage/emulated/0/Pictures/" + imgname);
                console.show();
                sleep(2000);
                back();
                提交任务();
                //任务后检测点赞数
                // hxh = dy_renwushu(dy_url, 1);
                // console.log("任务后喜欢" + hxh);
                // if (qxh < hxh) {
                //     console.info("点赞有效，提交任务；");
                //     提交任务();
                // }
                // else if (qxh == hxh) {
                //     q++;
                //     console.error("连续" + q + "次无效," + "最大无效5次");
                //     提交任务();
                //     console.log("点赞无效随机浏览");
                //     if (q == 5) {
                //         放弃任务();
                //         console.error("已连续最大无效次数停止运行");
                //         home();
                //         exit();
                //     }
                // }
                break;
            }
            else {
                放弃任务();
                back();
                break;
            }
        case 2:
            //关注
            console.log("获取到关注任务");
            //任务前检测关注任务数
            // var qgz = dy_renwushu(dy_url, 2);
            // console.log("任务前关注" + qgz);
            个人中心(dy_anchor_id);
            sleep(random(6000, 8000));
            if (className("android.widget.TextView").text("取消关注").findOne(1000)) {
                放弃任务();
                back();
                break;
            } else {
                if (className("android.widget.TextView").text("关注").findOne()) {
                    点击关注();
                    console.hide();
                    sleep(2000);
                    截图("/storage/emulated/0/Pictures/" + imgname);
                    console.show();
                    // var hgz = dy_renwushu(dy_url, 2);;
                    // console.log("任务后关注" + hgz);
                    // if (qgz < hgz) {
                    //     console.info("关注有效，提交任务；");
                    //     sleep(2000);
                    //     提交任务();
                    //     back();
                    //     sleep(3000);
                    // }
                    // else if (qgz == hgz) {
                    //     g++;
                    //     console.error("连续" + g + "次无效," + "最大无效5次；");
                    //     提交任务();
                    //     back();
                    //     if (g == 5) {
                    //         放弃任务();
                    //         console.error("已连续最大无效次数；");
                    //         home();
                    //         exit();
                    //     }
                    // }
                    提交任务();
                    back();
                    sleep(3000);
                    break;
                }
                else {
                    放弃任务();
                    back();
                    break;
                }
            }

        case 4:
            //评论
            console.log("获取到评论任务")
            抖音跳转(dyinId);
            sleep(random(6000, 8000));
            if (判断黑屏()) {
                点击评论();
                //点击评论框
                className("EditText").findOne().click();
                sleep(3000);
                setText(http.get("http://word.rainss.cn/api_system.php?type=txt").body.string());
                sleep(3000);
                //点击发送
                if (device.width == 1080 && device.height == 1920) {
                    click(random(982, 1016), random(755, 811));
                } else if (device.width == 1080 && device.height == 2160) {
                    click(random(988, 1022), random(951, 982));
                }
                console.hide();
                sleep(2000);
                截图("/storage/emulated/0/Pictures/" + imgname);
                console.show();
                提交任务();
                sleep(1000);
                back();
                sleep(1000);
                back();
                break;
            }

    }
}
//获取提交任务参数
function shot_img() {
    var str = http.post("http://zcore.zqzan.com/app/oss/shot_img", {}, {
        headers: {
            "Token": token
        }
    });
    strs = str.body.json();
    dir = strs.data.dir + "/" + strs.data.prefix + strs.data.expire + ".png";
    imgname = strs.data.prefix + strs.data.expire + ".png";
    img = "/storage/emulated/0/Pictures/" + imgname;
}
//提交任务
function 提交任务() {
    try {
        var ret = http.postMultipart("https://yun.zqzan.com/", {
            key: dir,
            policy: strs["data"]["policy"],
            OSSAccessKeyId: strs["data"]["accessid"],
            signature: strs["data"]["signature"],
            success_action_status: "200",
            file: open(img)
        });
        if (ret.statusCode !== 200) { console.error("上传图片失败"); return; }
        var submitUrl = "http://zcore.zqzan.com/app/douyin/submit/task"
        var submit = http.post(submitUrl, {
            "doit_id": doit_id,
            "shot_img": "https://zqzan.oss-cn-shanghai.aliyuncs.com/" + dir + "@!fwidth"

        }, {
            headers: {
                "Token": token
            }
        })
        var tj = submit.body.json();
        if (tj.msg == "操作成功") {
            console.info("提交成功,已完成" + 已完成() + "次任务");
        }
    }
    catch (err) {
        console.error("提交任务失败");
    }
}
//放弃任务
function 放弃任务() {
    var res = http.post("http://zcore.zqzan.com/app/douyin/giveup/task", {
        "doit_id": doit_id
    }, {
        "headers": {
            "Token": token
        }
    })
    var obj = res.body.json();
    var submit = obj.code;
    if (submit == 0) {
        console.log("放弃任务成功");
    }
}
//判断任务加载是否成功
function 判断黑屏() {   //img, "#ffececec", [942, 1039, 104, 356])
    var img = captureScreen();
    if (images.findColor(img, "#ffececec", {
        region: [906, 845, 170, 588],
        threshold: 5
    })
    ) {
        return true;
    } else {
        return false;
    }
}
//取md5值
function getMd5(string) {
    return java.math.BigInteger(1, java.security.MessageDigest.getInstance("MD5").digest(java.lang.String(string).getBytes())).toString(16);
};
//抖音跳转
function 抖音跳转(抖音ID) {
    app.startActivity({
        action: "android.intent.action.VIEW",
        data: "snssdk1128://aweme/detail/" + 抖音ID,
        packageName: "com.ss.android.ugc.aweme",
    });
}
//获取抖音ID
function 获取抖音ID(url) {
    var res = http.post("http://a1ka.com/zanzan/1.php", {
        "apiid": "235234523cdscsdcsd34564r34df3fd-",
        "txt": url
    })
    if (res.statusCode == 200) {
        var data = res.body.string()
        var xhgz = data.slice(4);
        var a = xhgz.split("-");
        var id = a[2];
        return id;
    } else {
        return false;
    }

}
//跳转抖音个人中心
function 个人中心(抖音ID) {
    app.startActivity({
        action: "android.intent.action.VIEW",
        data: "snssdk1128://user/profile/" + 抖音ID,
        packageName: "com.ss.android.ugc.aweme",
    });
}
//点赞
function 点赞(x, y, min, max, time) {
    for (i = 1; i <= time; i++) {
        var sj = random(min, max);
        click(x + sj, y + sj);
        sleep(80);
        click(x + sj, y + sj);
    }
}
function 点击关注() {
    className("android.widget.TextView").text("关注").findOne().click();
}
function 点击评论() {
    if (device.width == 1080 && device.height == 1920) {
        while (!click(random(958, 1018), random(1091, 1151)));
    } else if (device.width == 1080 && device.height == 2160) {
        while (!click(random(965, 1017), random(1265, 1309)));
    }
}
function 截图(StrPath) {
    try {
        captureScreen(StrPath);
        console.info("截图成功")
    } catch (err) {
        console.error("截图失败")
    }

}
function 截图路径() {
    var imgpath = "/storage/emulated/0/Pictures/";
    if (files.exists(imgpath)) {
        files.removeDir(imgpath);
        files.createWithDirs(imgpath);
    } else {
        files.createWithDirs(imgpath);
    }
}
//从配置文件读取微信号和执行次数以及速度
var loadConfig_Thread = threads.start(function () {


    ui.run(() => {

        //读取复选框
        //抖音
        if (STORAGE.get("dygz") == "true") {
            ui.dygz.setChecked(true);
        } else {
            ui.dygz.setChecked(false);
        }
        if (STORAGE.get("dypl") == "true") {
            ui.dypl.setChecked(true);
        } else {
            ui.dypl.setChecked(false);
        }
        if (STORAGE.get("dytj") == "true") {
            ui.dytj.setChecked(true);
        } else {
            ui.dytj.setChecked(false);
        }
        //快手
        if (STORAGE.get("ksgz") == "true") {
            ui.ksgz.setChecked(true);
        } else {
            ui.ksgz.setChecked(false);
        }
        //火山          
        if (STORAGE.get("hs_dz") == "true") {
            ui.hs_dz.setChecked(true);
        } else {
            ui.hs_dz.setChecked(false);
        }
        if (STORAGE.get("hs_gz") == "true") {
            ui.hs_gz.setChecked(true);
        } else {
            ui.hs_gz.setChecked(false);
        }
        if (STORAGE.get("hs_pl") == "true") {
            ui.hs_pl.setChecked(true);
        } else {
            ui.hs_pl.setChecked(false);
        }
        if (STORAGE.get("hs_zf") == "true") {
            ui.hs_zf.setChecked(true);
        } else {
            ui.hs_zf.setChecked(false);
        }
        //任务类型
        if (STORAGE.get("dy") == "true") {
            ui.dy.setChecked(true);
        } else {
            ui.dy.setChecked(false);
        }
        if (STORAGE.get("ks") == "true") {
            ui.ks.setChecked(true);
        } else {
            ui.ks.setChecked(false);
        }
        if (STORAGE.get("xhs") == "true") {
            ui.xhs.setChecked(true);
        } else {
            ui.xhs.setChecked(false);
        }
        if (STORAGE.get("hs") == "true") {
            ui.hs.setChecked(true);
        } else {
            ui.hs.setChecked(false);
        }

        //配置读取
        ui.kami.setText(STORAGE.get("kami"));
        ui.zzuser.setText(STORAGE.get("zzuser"));
        ui.zzpwd.setText(STORAGE.get("zzpwd"));
        ui.dyurl.setText(STORAGE.get("dy_url"));
        ui.rw_dy.setText(STORAGE.get("rw_dy"));
        ui.rw_ks.setText(STORAGE.get("rw_ks"));
        ui.rw_xhs.setText(STORAGE.get("rw_xhs"));
        ui.rw_hs.setText(STORAGE.get("rw_hs"));



    });

});
//浏览小视频
function 养号(num) {
    console.log("随机浏览视频")
    var i = 0;
    sleep(5000);
    while (i < num) {
        MaintenanceAccount(i);
        i++;
    }
}
//点击我
function dy_点击我() {
    var dy_me = className("android.widget.TextView").text("我").findOne();
    var x = dy_me.bounds().centerX();
    var y = dy_me.bounds().centerY();
    while (!click(x, y));
}
//检测任务是否有效
function dy_dianzan() {
    //点击我
    var dy_me = className("android.widget.TextView").text("我").findOne();
    var x = dy_me.bounds().centerX();
    var y = dy_me.bounds().centerY();
    while (!click(x, y));
    sleep(1000);
    //获取点赞数
    var a = id("ai").className("android.widget.TextView").depth(15).textContains("喜欢").findOne();
    var b = a.text();
    var c = b.replace(/[^0-9]/ig, "");
    sleep(1000);
    //点击首页
    var dy_index = className("android.widget.TextView").text("首页").findOne();
    var x1 = dy_index.bounds().centerX();
    var y1 = dy_index.bounds().centerY();
    while (!click(x1, y1));
    return c;

}
function dy_guanzhu() {
    var dy_gz = id("b1d").findOne()
    var gz = dy_gz.text();
    return gz;
}

//////////////////////////快手任务
function ks_主循环() {
    console.info("开始执行快手任务");
    var r = ui.rw_ks.text();
    if (ksgz) {
        //启动快手
        app.launchApp("快手");
        console.log("启动快手中...");
        sleep(8000);


        var i = 0;
        while (i < 2) {
            i++;
            if (ks_签到状态()) { //已签到执行快手任务
                while (ks_已完成() < r) {
                    var p = random(1, 3);
                    滑动浏览(p);
                    if (ks_获取任务(3)) {
                        if (ks_type == 2) {
                            if (aweme_id == "") {
                                ks_用户主页(anchor_id);
                                log("用户页关注");
                                sleep(random(5000, 15000));
                                if (id("header_follow_button").findOne(1000) == null) {
                                    console.error("未找到视频信息,或已关注，");
                                    ks_放弃任务();

                                } else {
                                    ks_用户关注();
                                    sleep(3000);
                                    ks_提交任务();
                                    sleep(1000);
                                }
                            } else {
                                ks_作品主页(aweme_id);
                                log("作品页关注");
                                sleep(random(5000, 8000));
                                if (id("follow_text_container").findOne(1000) == null) {
                                    console.error("未找到视频信息，或已关注");
                                    ks_放弃任务();

                                } else {
                                    ks_作品关注();
                                    sleep(3000);
                                    ks_提交任务();
                                    sleep(1000);
                                }
                            }
                        }
                        else if (ks_type == 1) {
                            //点赞任务
                            ks_作品主页(aweme_id);
                            sleep(random(5000, 15000));
                            if (id("like_layout").findOne(1000)) {
                                id("like_layout").findOne().click();
                                sleep(3000);
                                ks_提交任务();
                                sleep(1000);
                                back();
                            } else {
                                console.error("没有找到视频信息");
                                ks_放弃任务();
                            }
                        }
                        else {
                            console.log("没有任务")
                        }
                    }
                }
                console.info("已完成指定任务");
                break;
            }
            else { //没有签到执行签到任务
                console.log("没签到,开始签到");
                //打开快手个人中心
                ks_用户主页();
                sleep(3000);
                var ks_id = id("profile_user_kwai_id").findOne().text();
                var ks_id = ks_id.substr(6).toString();
                if (ks_id == kshou_dataid) {
                    console.hide();
                    if (id("profile_settings_button").findOne()) {
                        sleep(3000);
                        ks_签到();
                        sleep(500);
                        className("android.view.View").desc("发现").findOne().click();
                        console.show();
                        sleep(1000);
                    } else {
                        console.error("没有找到个人中心");
                    }
                } else {
                    console.error("快手ID不相符");
                    return;
                }
            }
        }
    }
}
function ks_签到状态() {
    try {
        var res = http.get("http://zcore.zqzan.com/app/kshou/summary/info/v2", { headers: { "Token": token } });
        var data = res.body.json();
        var is_signed = data.data.is_signed;
        kshou_dataid = data.data.kshou_dataid;
        if (is_signed == true) {
            return true;
        } else {
            return false;
        }
    }
    catch (err) {
        console.error("获取签到状态失败")
    }
}
function ks_签到() {
    //获取上传参数
    var res = http.post("http://zcore.zqzan.com/app/oss/sign_img", {}, { headers: { "Token": token } });
    var data = res.body.json().data;
    var key = data.dir + "/" + data.prefix + data.expire + ".png"
    var imgname = data.prefix + data.expire + ".png";
    截图("/storage/emulated/0/Pictures/" + imgname);
    back();
    var img = "/storage/emulated/0/Pictures/" + imgname;
    // 上传图片
    var upimg = http.postMultipart("https://yun.zqzan.com/", {
        key: key,
        policy: data.policy,
        OSSAccessKeyId: data.accessid,
        signature: data.signature,
        success_action_status: "200",
        file: open(img)
    })
    var r = upimg.statusCode
    if (r !== 200) { console.info("图片上传失败"); return; }
    //提交签到
    var sign = http.post("http://zcore.zqzan.com/app/kshou/do/sign/everyday", {
        "img_url": "https://yun.zqzan.com/" + key + "@!fwidth"
    }, { headers: { "Token": token } });
    if (sign.body.json().code == 0) {
        console.info("签到成功");
    } else {
        console.error("签到失败");
    }
}
function ks_获取任务(num) {
    try {
        var res = http.post("http://zcore.zqzan.com/app/kshou/pull/one/v2", {
            "access": num
        }, {
            "headers": {
                "Token": token,
            }
        })
        var data = res.body.json().data;
        doit_id = data.id;
        //用户主页
        anchor_id = data.anchor_id;
        //作品主页
        aweme_id = data.aweme_id;
        //任务类型
        ks_type = data.type;
        // log(aweme_id)
        if (ks_type == 2) {
            console.info("获取到关注任务");
            return true;
        } else if (ks_type == 1) {
            console.info("获取到点赞任务");
            return true;
        } else {
            console.error("暂时没有任务，请稍后");
        }
    } catch (err) {
        console.error("获取任务失败" + err.message);
        return false;
    }



}
/**
 * 快手提交任务
 */
function ks_提交任务() {

    try {
        console.hide();
        sleep(500);
        //获取上传参数
        var res = http.post("http://zcore.zqzan.com/app/oss/shot_img", {}, { headers: { "Token": token } });
        var data = res.body.json().data;
        var key = data.dir + "/" + data.prefix + data.expire + ".png"
        var imgname = data.prefix + data.expire + ".png";

        截图("/storage/emulated/0/Pictures/" + imgname);
        sleep(2000);
        console.show();
        back();
        var img = "/storage/emulated/0/Pictures/" + imgname;
        sleep(1000);
        // 上传图片
        // http.__okhttp__.setMaxRetries(2);
        var upimg = http.postMultipart("https://yun.zqzan.com/", {
            key: key,
            policy: data.policy,
            OSSAccessKeyId: data.accessid,
            signature: data.signature,
            success_action_status: "200",
            file: open(img)
        })
        var r = upimg.statusCode
        if (r !== 200) { console.info("图片上传失败"); return; }
        //提交任务
        var submit = http.post("http://zcore.zqzan.com/app/kshou/submit/task/v2", {
            "doit_id": doit_id,
            "shot_img": "https://yun.zqzan.com/" + key + "@!fwidth"
        }, { headers: { "Token": token } });


        var tj = submit.body.json().code
        if (tj == 0) {
            console.info("提交成功," + "已完成" + ks_已完成() + "次任务");
            sleep(1000);
        } else {
            console.error("提交失败");
            log(submit.body.json())
        }
    } catch (e) {
        console.log(e.message);
    }



}
function ks_已完成() {
    try {
        var res = http.get("http://zcore.zqzan.com/app/kshou/summary/info/v2", { headers: { "Token": token } });
        var data = res.body.json().data.today_count;
        return data;
    } catch (err) {
        console.error("获取已完成任务失败")
    }



}
function ks_放弃任务() {
    var res = http.post("http://zcore.zqzan.com/app/kshou/giveup/task", { "doit_id": doit_id }, { headers: { "Token": token } });
    if (res.body.json().code == 0) {
        console.error("放弃任务成功");
        back();
    }
}
function ks_用户主页(id) {
    app.startActivity({
        action: "android.intent.action.VIEW",
        data: "kwai://profile/" + id,
        packageName: "com.smile.gifmaker",
    });
}
function ks_作品主页(id) {
    app.startActivity({
        action: "android.intent.action.VIEW",
        data: "kwai://work/" + id,
        packageName: "com.smile.gifmaker",
    });
}
function ks_作品关注() { //作品页关注
    var ks_gz = id("follow_text_container").findOne().bounds();
    var x = ks_gz.centerX();
    var y = ks_gz.centerY();
    while (!click(x, y));
}
function ks_用户关注() { //用户页关注
    var ks_gz = id("header_follow_button").findOne().bounds();
    var x = ks_gz.centerX();
    var y = ks_gz.centerY();
    while (!click(x + 60, y));
}
function 滑动浏览(num) {
    console.log("随机浏览" + num + "个小视频");
    for (i = 0; i < num; i++) {
        sleep(1000);
        swipe(550, 1349, 600, 1168, 35);
        sleep(1000);
        click(828, 1380);
        sleep(random(4000, 12000));
        back();
        sleep(3000);
    }

}
/////////////////////////火山
function hs_主循环() {
    var r = ui.rw_hs.text();
    let hs_dz = ui.hs_dz.isChecked();
    let hs_gz = ui.hs_gz.isChecked();
    let hs_pl = ui.hs_pl.isChecked();
    let hs_zf = ui.hs_zf.isChecked();
    if (hs_dz && hs_gz) {
        //点赞关注
        var access = 3;
        log("dzgz")
    }
    else if (hs_dz) {
        //点赞
        var access = 1;
        log("dz")
    }
    else if (hs_gz) {
        var access = 2;
        log("gz")
    }

    var i = 0;
    var gz = 0;
    launchApp("抖音火山版");
    sleep(5000);
    while (i < 2) {
        i++;
        var r = ui.rw_hs.text();
        if (hs_签到状态()) {
            while (hs_已完成() < r) {
                if (hs_获取任务(access)) {
                    gz++;
                    if (hs_type == 2) {
                        HS_用户页(anchor_id);
                        sleep(2000);
                        console.hide();
                        sleep(random(4000, 8000));
                        if (className("android.widget.TextView").text("总火苗").findOne(1000)) {
                            var a = className("android.widget.TextView").text("关注").findOne();
                            var b = a.bounds();
                            click(b.centerX(), b.centerY());
                            sleep(1000);
                            hs_提交任务();
                            console.log("已完成" + gz + "次关注任务");
                            if (gz == 90) {
                                var access = 1;
                            }

                            sleep(2000);
                            swipe(550, 1349, 600, 1168, 35);
                            sleep(1000);
                            click(device.width / 1.5, device.height / 3);
                            sleep(2000);
                            养号(random(2, 3));
                            back();
                            sleep(2000);
                        }
                        else if (className("android.widget.TextView").text("总火苗").findOne(1000) == null) {
                            console.show();
                            console.error("没有找到视频信息，放弃任务");
                            hs_放弃任务();
                            sleep(5000);
                        }
                    }
                    else if (hs_type == 1) {
                        //点赞任务
                        HS_作品页(aweme_id);
                        sleep(random(8000, 12000));
                        // if (单点比色(812, 156, "#ff000000")) {//判断是否黑屏
                        //     console.error("未找到视频信息，放弃任务")
                        //     hs_放弃任务();
                        //     back();
                        // } else {
                        console.hide();
                        点赞(576, 1100, -200, 200, 2);
                        sleep(2000);
                        hs_提交任务();
                        sleep(2000);
                        swipe(550, 1349, 600, 1168, 35);
                        sleep(1000);
                        click(device.width / 1.5, device.height / 3);
                        sleep(2000);
                        养号(random(1, 3));
                        back();
                        sleep(2000);
                        // }

                    }
                } else {
                    //没有任务 
                    sleep(2000);
                    click(device.width / 1.5, device.height / 3);
                    养号(random(2, 5));
                    back();
                    sleep(2000);
                }
            }
            console.log("已完成指定任务")


        }
        else {
            console.log("未签到，开始签到任务");
            HS_用户页(hshan_dataid);
            if (className("android.widget.TextView").text("总火苗").findOne()) {
                console.hide();
                sleep(4000);
                hs_签到();
                console.show();
                sleep(5000);

            }

        }
    }
}

function hs_点赞() {
    if (ui.hs_dz.isChecked()) {

    }
}
function hs_签到状态() {
    try {
        var res = http.get("http://zcore.zqzan.com/app/hshan/summary/info", { headers: { "Token": token } });
        var data = res.body.json();
        var is_signed = data.data.is_signed;
        hshan_dataid = data.data.hshan_dataid;
        log(hshan_dataid)
        if (is_signed == true) {
            return true;
        } else {
            return false;
        }
    }
    catch (err) {
        console.error("获取签到状态失败")
    }

}
function hs_签到() {
    //获取上传参数
    var res = http.post("http://zcore.zqzan.com/app/oss/sign_img", {}, { headers: { "Token": token } });
    var data = res.body.json().data;
    var key = data.dir + "/" + data.prefix + data.expire + ".png"
    var imgname = data.prefix + data.expire + ".png";
    截图("/storage/emulated/0/Pictures/" + imgname);
    back();
    var img = "/storage/emulated/0/Pictures/" + imgname;
    // 上传图片
    var upimg = http.postMultipart("https://yun.zqzan.com/", {
        key: key,
        policy: data.policy,
        OSSAccessKeyId: data.accessid,
        signature: data.signature,
        success_action_status: "200",
        file: open(img)
    })
    var r = upimg.statusCode
    if (r !== 200) { console.info("图片上传失败"); return; }
    //提交签到
    var sign = http.post("http://zcore.zqzan.com/app/hshan/do/sign/everyday", {
        "img_url": "https://yun.zqzan.com/" + key + "@!fwidth"
    }, { headers: { "Token": token } });
    if (sign.body.json().code == 0) {
        console.info("签到成功");
        sleep(2000);
    } else {
        console.error("签到失败");
        sleep(2000);
    }
}
function hs_获取任务(access) {
    try {
        var res = http.post("http://zcore.zqzan.com/app/hshan/pull/one", {
            "access": access
        }, {
            "headers": {
                "Token": token,
            }
        })
        var data = res.body.json().data;
        // log(data)
        doit_id = data.id;
        //用户主页
        anchor_id = data.anchor_id;
        //作品主页
        aweme_id = data.aweme_id;
        //任务类型
        hs_type = data.type;
        // log(aweme_id)
        if (hs_type == 2) {
            console.info("获取到关注任务");
            return true;
        } else if (hs_type == 1) {
            console.info("获取到点赞任务");
            return true;
        } else {
            console.error("获取任务失败");
            return false;
        }
    } catch (err) {
        console.error("获取任务失败");
        return false;
    }



}
function hs_提交任务() {

    sleep(1000);
    //获取上传参数
    var res = http.post("http://zcore.zqzan.com/app/oss/shot_img", {}, { headers: { "Token": token } });
    var data = res.body.json().data;
    var key = data.dir + "/" + data.prefix + data.expire + ".png"
    var imgname = data.prefix + data.expire + ".png";

    截图("/storage/emulated/0/Pictures/" + imgname);
    sleep(1000);
    console.show();
    back();
    var img = "/storage/emulated/0/Pictures/" + imgname;
    sleep(1000);
    // 上传图片
    try {
        http.__okhttp__.setMaxRetries(3);
        var upimg = http.postMultipart("https://yun.zqzan.com/", {
            key: key,
            policy: data.policy,
            OSSAccessKeyId: data.accessid,
            signature: data.signature,
            success_action_status: "200",
            file: open(img)
        })
        var r = upimg.statusCode
        if (r !== 200) { console.info("图片上传失败"); return; }
    } catch (e) {
        console.log("上传图片失败");
    }

    //提交任务
    var submit = http.post("http://zcore.zqzan.com/app/hshan/submit/task", {
        "doit_id": doit_id,
        "shot_img": "https://yun.zqzan.com/" + key + "@!fwidth"
    }, { headers: { "Token": token } });


    var tj = submit.body.json().code
    if (tj == 0) {
        console.info("提交成功," + "已完成" + hs_已完成() + "次任务");
        sleep(1000);
    } else {
        console.error("提交失败");
        log(submit.body.json());
    }

}
function hs_已完成() {
    try {
        var res = http.get("http://zcore.zqzan.com/app/hshan/summary/info", { headers: { "Token": token } });
        var data = res.body.json().data.today_count;
        return data;
    } catch (err) {
        console.error("获取已完成任务失败")
    }



}
function hs_放弃任务() {
    var res = http.post("http://zcore.zqzan.com/app/hshan/giveup/task", { "doit_id": doit_id }, { headers: { "Token": token } });
    if (res.body.json().code == 0) {
        console.error("放弃任务成功");
        back();
    }
}
function HS_用户页(id) {
    app.startActivity({//874819275989539
        action: "android.intent.action.VIEW",
        data: "snssdk1112://profile?id=" + id,
        packageName: "com.ss.android.ugc.live",
    });
}
function HS_作品页(id) {
    app.startActivity({//6804948541287550215
        action: "android.intent.action.VIEW",
        data: "snssdk1112://item?id=" + id,
        packageName: "com.ss.android.ugc.live",
    });
}
function 单点比色(x, y, color1) {
    //为真时颜色相同
    var img = captureScreen();
    var color = images.pixel(img, x, y);
    var rgb = colors.toString(color)
    if (rgb == color1) {
        return true;
    } else {
        return false;
    }
}

/**
 * 滑动视频养号
 */

function MaintenanceAccount(i) {
    var time = random(4000, 15000);
    toastLog("第" + (i + 1) + "个视频，请等待" + time / 1000 + "秒");
    sleep(time);
    //开始滑动视频
    var x1 = random(device.width / 4, (device.width / 4) * 3);
    var y1 = random((device.height / 4) * 3.1, (device.height / 4) * 3.3);
    var x2 = random(device.width / 4, (device.width / 4) * 3);
    var y2 = random((device.height / 4) * 0.7, (device.height / 4) * 0.5);
    var s = random(35, 80);
    RandomSwipe(x1, y1, x2, y2, s);
}
//-------------------------曲线滑动-----------------------------//
/**
 * 仿真随机带曲线滑动（视频/小说）
 * @param {起点x} qx 
 * @param {起点y} qy 
 * @param {终点x} zx 
 * @param {终点y} zy 
 * @param {过程耗时单位毫秒} time 
 */
function RandomSwipe(qx, qy, zx, zy, time) {
    var xxy = [time];
    var point = [];
    var dx0 = {
        "x": qx,
        "y": qy
    };
    var dx1 = {
        "x": random(qx - (device.width / 4) * 0.25, qx + (device.width / 4) * 0.25),
        "y": random(qy, qy + 50)
    };
    var dx2 = {
        "x": random(zx - (device.width / 4) * 0.25, zx + (device.width / 4) * 0.25),
        "y": random(zy, zy + 50)
    };
    var dx3 = {
        "x": zx,
        "y": zy
    };
    for (var i = 0; i < 4; i++) {
        eval("point.push(dx" + i + ")");
    };
    for (let i = 0; i < 1; i += 0.08) {
        xxyy = [parseInt(bezier_curves(point, i).x), parseInt(bezier_curves(point, i).y)]
        xxy.push(xxyy);
    }
    gesture.apply(null, xxy);
};
function bezier_curves(cp, t) {
    cx = 3.0 * (cp[1].x - cp[0].x);
    bx = 3.0 * (cp[2].x - cp[1].x) - cx;
    ax = cp[3].x - cp[0].x - cx - bx;
    cy = 3.0 * (cp[1].y - cp[0].y);
    by = 3.0 * (cp[2].y - cp[1].y) - cy;
    ay = cp[3].y - cp[0].y - cy - by;

    tSquared = t * t;
    tCubed = tSquared * t;
    result = {
        "x": 0,
        "y": 0
    };
    result.x = (ax * tCubed) + (bx * tSquared) + (cx * t) + cp[0].x;
    result.y = (ay * tCubed) + (by * tSquared) + (cy * t) + cp[0].y;
    return result;
};
//-------------------------曲线滑动----------------------------//