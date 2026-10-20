"""Static contract checks for the FAT/CARGA pilot. Does not execute the ERP."""

import json
import re
from pathlib import Path


HERE = Path(__file__).resolve().parent
FEATURE = HERE.parent
ROOT = FEATURE.parents[2]
CARGA = ROOT / "docs/assets/emDesenvolvimento/carga"


def require(condition, message):
    if not condition:
        raise AssertionError(message)


payload_text = (CARGA / "TDD_FAT_CARGA_JSON.json").read_text(encoding="utf-8")
payload = json.loads(payload_text)
require(payload["PEDIDO_VENDA"] == 843172, "Approved order code must be used")
require(payload["DESCRICAO_CARGA"], "Cargo description is required")
assertion = payload["resultadoEsperado"]["valor"][0]
require(assertion == {"campo": "CODIGO_CARGA", "tipo_campo": "ftInteger", "operacao": "Maior", "resultado": 0, "cds": "CDSCadastro", "dm": "DMCadCarga"}, "Expected result must check a positive load ID")

sync = (ROOT / "docs/assets/configuracoesGerais/Sincronizar/P39_TDD_SINCRONIZAR_CASOS_TESTE_REGISTRADOS.pas").read_text(encoding="cp1252")
require(sync.count("RegistrarCasoTeste('FATURAMENTO',             'CARGA',                 'TDD_FAT_CARGA'") == 1, "Cargo sync entry must occur once")
require("'TDD_FAT_CARGA_JSON'" in sync, "Cargo sync must use the JSON unit")

inventory = (FEATURE / "inventario-executavel.md").read_text(encoding="utf-8")
tabs = []
controls = set()
for row in inventory.splitlines():
    match = re.match(r"\| `([^`]+)` \| `([^`]+)` \|", row)
    if match and (match.group(1) == "PageControl1" or "/" in match.group(1)):
        tabs.append(match.group(2))
        controls.add(match.group(1).split("/")[-1])
require(len(tabs) == 28 and len(set(tabs)) == 28, "Inventory must contain 28 distinct tabs")
require(len(controls) == 5, "Inventory must contain five page controls")
mapper = (CARGA / "TDD_FAT_MAPEAMENTO_COMPONENTES_CARGA.pas").read_text(encoding="ascii")
mapped_tabs = re.findall(r"^  RegistrarAbaCarga\('([^']+)'\);$", mapper, re.MULTILINE)
require(set(mapped_tabs) == set(tabs) and len(mapped_tabs) == 28, "Mapper tabs differ from executable inventory")
for control in controls:
    require(f"'{control}'" in mapper, f"Page control missing: {control}")

processor = (CARGA / "P39_TDD_FAT_PROCESSAMENTO_CARGA.pas").read_text(encoding="utf-8")
require("SetTDDUnit('TDD_FAT_CARGA')" in processor, "Processor must call Cargo case")
require("AddParamsRun('''FATURAMENTO''')" in processor, "Processor module mismatch")
require("AddParamsRun('''CARGA''')" in processor, "Processor area mismatch")
require(processor.count('}Executar;') == 1, "Processor must execute IRunner once")

case = (CARGA / "TDD_FAT_CARGA.pas").read_text(encoding="ascii")
require("lJSONCompacto := ExecutarMetodoDeObjeto(lObjeto, 'ToJSON')" in case, "Runner JSON must be compacted before tag wrappers")
require("FieldByName('DOCUMENTO_CARDOC').AsInteger := FPedidoVendaCarga" in case, "The detail must use the field confirmed in CARGA_DOCUMENTOS")
require("FROM CARGA_DOCUMENTOS WHERE CARGA_CARDOC" in case, "The persisted load/order link must be checked")
require("FieldByName('DTEMISSAO_CARGA').AsDateTime" in case, "Required issue date must be filled")
require("FieldByName('SERVICODEENVIO_CARGA').AsInteger" in case, "Required shipping service must be filled")
require("FNomeMetodoAtual := 'IRUNNER';" in case, "Successful cleanup must return control to the batch runner")

print("Static FAT/CARGA contracts: OK (28 tabs, 5 controls, schema fields, JSON, sync, IRunner).")
