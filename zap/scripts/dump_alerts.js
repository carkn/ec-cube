var control
if (!control) control = Java.type("org.parosproxy.paros.control.Control").getSingleton()

var Alert = Java.type("org.parosproxy.paros.core.scanner.Alert");
var Stats = Java.type("org.zaproxy.zap.utils.Stats");
var Collectors = Java.type("java.util.stream.Collectors");

var extAlert = control.getExtensionLoader().getExtension(org.zaproxy.zap.extension.alert.ExtensionAlert.NAME);
var alerts = extAlert.getAllAlerts().stream().map(function(a) {
    return {
        "ruleid": a.pluginId,
        "url": a.uri,
        "param": a.param,
        "attack": a.attack,
        "evidence": a.evidence,
        "risk": a.risk,
        "confidence": a.confidence
    }
}).collect(Collectors.toList());

var json = Java.type("net.sf.json.JSONArray").fromObject(alerts).toString()
java.nio.file.Files.write(
    java.nio.file.Paths.get('/tmp/alerts.json'),
    java.util.Arrays.asList(json),
    java.nio.charset.Charset.forName('UTF-8')
)