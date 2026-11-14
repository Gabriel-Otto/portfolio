# Lakehouse no Microsoft Fabric para inteligência comercial farmacêutica

> Cliente da indústria farmacêutica, atendido pela Ottorise (2025 – hoje). Detalhes e dados do cliente são confidenciais; a [demo deste repositório](../demos/medallion-vendas) reproduz o padrão com dados sintéticos.

**Contexto.** Os indicadores da força de vendas e do trade dependiam de processos espalhados em Alteryx, Excel e Qlik, com fontes que não conversavam entre si: CRM (Salesforce / IQVIA OCE), ERP (SAP S/4HANA), auditoria de mercado (IQVIA CloseUp) e planilhas manuais.

**O que eu fiz**
- Desenhei a arquitetura em camadas no **Fabric** (bronze, silver, gold) com **um notebook de ingestão por fonte** e padrão de nomes e governança.
- Integrei CRM, ERP, auditoria e bases manuais em **um único modelo**.
- Remontei os processos legados no Fabric e publiquei **modelos semânticos reutilizáveis (Direct Lake)**.
- Construí dashboards **Power BI** para força de vendas e trade: cobertura e frequência de visitas, direcionamento regional e objetivos de sell-out.
- Documentei tudo para outras pessoas conseguirem manter e evoluir a solução.

**Resultado.** As fontes passaram a viver em um só lugar, com regras de negócio centralizadas, e as áreas consomem os mesmos números a partir dos modelos semânticos compartilhados, sem cada uma manter sua própria planilha.

**Stack:** Microsoft Fabric (Lakehouse, Notebooks, Pipelines, Direct Lake) · SQL · Power BI (DAX) · Salesforce OCE · SAP S/4HANA · IQVIA
