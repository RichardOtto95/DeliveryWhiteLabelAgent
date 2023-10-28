import 'package:delivery_agent_white_label/app/modules/main/main_store.dart';
import 'package:delivery_agent_white_label/app/modules/support/support_store.dart';

import 'package:delivery_agent_white_label/app/shared/utilities.dart';
import 'package:delivery_agent_white_label/app/shared/widgets/default_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'dart:math' as math;

class SupportPage extends StatefulWidget {
  const SupportPage({Key? key}) : super(key: key);

  @override
  _SupportPageState createState() => _SupportPageState();
}

class _SupportPageState extends ModularState<SupportPage, SupportStore> {
  final MainStore mainStore = Modular.get();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Observer(
        builder: (context) {
          return Stack(
            children: [
              SingleChildScrollView(
                physics: BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics()),
                controller: mainStore.mainScrollController,
                padding: EdgeInsets.only(
                    top: viewPaddingTop(context) + wXD(60, context)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(
                        wXD(18, context),
                        wXD(16, context),
                        0,
                        wXD(0, context),
                      ),
                      child: Text(
                        "Como podemos ajudar?",
                        style: textFamily(
                          context,
                          fontSize: 16,
                          color:
                              getColors(context).onBackground.withOpacity(.7),
                        ),
                      ),
                    ),
                    // Center(
                    //   child: Container(
                    //     height: wXD(58, context),
                    //     width: wXD(362, context),
                    //     padding:
                    //         EdgeInsets.symmetric(horizontal: wXD(24, context)),
                    //     margin: EdgeInsets.only(bottom: wXD(8, context)),
                    //     decoration: BoxDecoration(
                    //       border: Border.all(color: getColors(context).onSurface),
                    //       color:getColors(context).onSurface,
                    //       borderRadius: BorderRadius.all(Radius.circular(3)),
                    //       boxShadow: [
                    //         BoxShadow(
                    //           blurRadius: 3,
                    //           color: getColors(context).onBackground.withOpacity(.15),
                    //           offset: Offset(0, 3),
                    //         ),
                    //       ],
                    //     ),
                    //     child: Row(
                    //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //       children: [
                    //         SvgPicture.asset(
                    //           "./assets/svg/search.svg",
                    //           height: wXD(20, context),
                    //           width: wXD(20, context),
                    //         ),
                    //         Container(
                    //           width: wXD(261, context),
                    //           child: TextField(
                    //             decoration: InputDecoration.collapsed(
                    //               hintText: "Buscar",
                    //               hintStyle: textFamily(context,
                    //                 fontSize: 14,
                    //                 color: getColors(context).onBackground.withOpacity(.7).withOpacity(.5),
                    //               ),
                    //             ),
                    //           ),
                    //         )
                    //       ],
                    //     ),
                    //   ),
                    // ),
                    // Center(
                    //   child: Container(
                    //     height: wXD(85, context),
                    //     width: wXD(362, context),
                    //     // padding: EdgeInsets.only(left: wXD(11, context)),
                    //     decoration: BoxDecoration(
                    //       border: Border.all(color: getColors(context).onSurface),
                    //       color:getColors(context).onSurface,
                    //       borderRadius: BorderRadius.all(Radius.circular(3)),
                    //       boxShadow: [
                    //         BoxShadow(
                    //           blurRadius: 3,
                    //           color: getColors(context).onBackground.withOpacity(.15),
                    //           offset: Offset(0, 3),
                    //         ),
                    //       ],
                    //     ),
                    //     child: Row(
                    //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    //       children: [
                    //         SvgPicture.asset(
                    //           "./assets/svg/called.svg",
                    //           height: wXD(54, context),
                    //           width: wXD(54, context),
                    //         ),
                    //         Text(
                    //           "Confira os chamados abertos aqui",
                    //           style: textFamily(context,
                    //             color: getColors(context).onBackground.withOpacity(.9),
                    //             fontWeight: FontWeight.w400,
                    //           ),
                    //         ),
                    //         Icon(
                    //           Icons.arrow_forward_rounded,
                    //           size: wXD(25, context),
                    //           color: getColors(context).primary,
                    //         ),
                    //       ],
                    //     ),
                    //   ),
                    // ),
                    // Center(
                    //   child: Container(
                    //     height: wXD(95, context),
                    //     width: wXD(362, context),
                    //     padding: EdgeInsets.symmetric(
                    //         horizontal: wXD(18, context),
                    //         vertical: wXD(18, context)),
                    //     margin: EdgeInsets.only(top: wXD(15, context)),
                    //     decoration: BoxDecoration(
                    //       border: Border.all(color: getColors(context).primary.withOpacity(.4)),
                    //       color:getColors(context).onSurface,
                    //       borderRadius: BorderRadius.all(Radius.circular(3)),
                    //     ),
                    //     child: Column(
                    //       crossAxisAlignment: CrossAxisAlignment.start,
                    //       children: [
                    //         Text(
                    //           "Aplicativo",
                    //           style: textFamily(context,
                    //             fontSize: 15,
                    //             color: getColors(context).onBackground,
                    //           ),
                    //         ),
                    //         Spacer(),
                    //         Row(
                    //           children: [
                    //             Text(
                    //               "Em quais cidades é possível realizar entregas usando o\napp Scorefy para entregadores?",
                    //               style: textFamily(context,
                    //                 fontSize: 10,
                    //                 color: getColors(context).onBackground.withOpacity(.9),
                    //               ),
                    //             ),
                    //             Spacer(),
                    //             Transform.rotate(
                    //               angle: math.pi / 2,
                    //               child: Icon(
                    //                 Icons.arrow_forward_ios_rounded,
                    //                 size: wXD(15, context),
                    //                 color: getColors(context).primary,
                    //               ),
                    //             ),
                    //           ],
                    //         )
                    //       ],
                    //     ),
                    //   ),
                    // ),
                    // Center(
                    //   child: Container(
                    //     height: wXD(159, context),
                    //     width: wXD(362, context),
                    //     padding: EdgeInsets.symmetric(
                    //         horizontal: wXD(18, context),
                    //         vertical: wXD(18, context)),
                    //     margin: EdgeInsets.only(top: wXD(15, context)),
                    //     decoration: BoxDecoration(
                    //       border: Border.all(color: getColors(context).primary.withOpacity(.4)),
                    //       color:getColors(context).onSurface,
                    //       borderRadius: BorderRadius.all(Radius.circular(3)),
                    //     ),
                    //     child: Column(
                    //       crossAxisAlignment: CrossAxisAlignment.start,
                    //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //       children: [
                    //         Padding(
                    //           padding:
                    //               EdgeInsets.only(bottom: wXD(11, context)),
                    //           child: Text(
                    //             "Não consigo fazer entregas",
                    //             style: textFamily(context,
                    //               fontSize: 15,
                    //               color: getColors(context).onBackground,
                    //             ),
                    //           ),
                    //         ),
                    //         Questions(title: "Atualização do aplicativo"),
                    //         Questions(title: "Como ficar online"),
                    //         Questions(title: "Desalocação automática"),
                    //         Questions(title: "Não recebo pedidos"),
                    //         Questions(title: "Problema na localização"),
                    //       ],
                    //     ),
                    //   ),
                    // ),
                    // Center(
                    //   child: Container(
                    //     height: wXD(246, context),
                    //     width: wXD(362, context),
                    //     padding: EdgeInsets.symmetric(
                    //         horizontal: wXD(18, context),
                    //         vertical: wXD(18, context)),
                    //     margin: EdgeInsets.only(top: wXD(15, context)),
                    //     decoration: BoxDecoration(
                    //       border: Border.all(color: getColors(context).primary.withOpacity(.4)),
                    //       color:getColors(context).onSurface,
                    //       borderRadius: BorderRadius.all(Radius.circular(3)),
                    //     ),
                    //     child: Column(
                    //       crossAxisAlignment: CrossAxisAlignment.start,
                    //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //       children: [
                    //         Padding(
                    //           padding:
                    //               EdgeInsets.only(bottom: wXD(11, context)),
                    //           child: Text(
                    //             "Offline",
                    //             style: textFamily(context,
                    //               fontSize: 15,
                    //               color: getColors(context).onBackground,
                    //             ),
                    //           ),
                    //         ),
                    //         Questions(
                    //           title:
                    //               "Estou com dificuldades de realizar o Login ou o app não abre",
                    //         ),
                    //         Questions(
                    //           title:
                    //               "Estou com dificuldades/dúvidas e para finalizar meu cadastro, o que devo fazer?",
                    //         ),
                    //         Questions(title: "Estou deslogado"),
                    //         Questions(
                    //           title:
                    //               "Quais veículos posso utilizar para realizar entregas através da plataforma Scorefy para Entregadores?",
                    //         ),
                    //         Questions(
                    //           title:
                    //               "Qual tipo de equipamento eu preciso ter para começar a realizar entregas?",
                    //         ),
                    //         Questions(
                    //           title:
                    //               "Quero ser um entregador autônomo usando o Scorefy para Entregadores",
                    //         ),
                    //       ],
                    //     ),
                    //   ),
                    // ),
                    Center(
                      child: Container(
                        // height: wXD(77, context),
                        width: wXD(362, context),
                        padding: EdgeInsets.symmetric(
                            horizontal: wXD(18, context),
                            vertical: wXD(18, context)),
                        margin: EdgeInsets.only(top: wXD(15, context)),
                        decoration: BoxDecoration(
                          border: Border.all(
                              color:
                                  getColors(context).primary.withOpacity(.4)),
                          color: getColors(context).surface,
                          borderRadius: BorderRadius.all(Radius.circular(3)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding:
                                  EdgeInsets.only(bottom: wXD(11, context)),
                              child: Text(
                                "Perguntas frequentes",
                                style: textFamily(
                                  context,
                                  fontSize: 15,
                                  color: getColors(context).onBackground,
                                ),
                              ),
                            ),
                            Questions(
                              title: "O que é o MercadoExpresso?",
                              answer:
                                  "MercadoExpresso é uma plataforma na qual você pode distribuir seus produtos a clientes de sua região, em menos de 90 minutos e sem nenhum investimento.",
                            ),
                            Questions(
                              title: "O que é um Agente parceiro?",
                              answer:
                                  "Agente parceiro é um profissional autônomo que recebe demandas de serviços da plataforma e, dentro de sua conveniência, escolhe em quais deseja atuar. Seja como renda extra ou principal, os Agentes parceiros são remunerados pelos serviços que geralmente se relacionam a coletar pedidos em fornecedores e entregar a clientes, mas não se limitam a isso, visando auxiliar a MercadoExpresso a oferecer uma experiência diferenciada para seus clientes.",
                            ),
                            Questions(
                              title:
                                  "Quais são as etapas para eu me tornar um Agente parceiro da MercadoExpresso?",
                              answer:
                                  """É fácil ser um Agente parceiro. Basta seguir esses passos:

1 - Baixe o aplicativo do Agente na [PLAYSTORE] ou na [APPLESTORE];
2- Faça o cadastro fornecendo os dados solicitados;
3 - Fotografe os documentos solicitados, clique no botão “Enviar” e aguarde a confirmação;
4 - No seu primeiro acesso, você precisará assistir uma apresentação online em vídeo. Ele tem todas as informações importantes para você se tornar um Agente 5 estrelas e aumentar sua renda.
5 - Depois disso é só aguardar sua ativação na plataforma para começar a atender as missões e faturar. 
""",
                            ),
                            Questions(
                              title:
                                  "Quais modelos de veículos são aceitos na plataforma?",
                              answer: """* Motos
* Carros
* Veículos utilitários
* Vans
* Carretos e VUCs
""",
                            ),
                            Questions(
                              title: "O que são Missões?",
                              answer:
                                  "Missões são solicitações de serviço (geralmente relacionados a entregas) que são disponibilizadas para Agentes parceiros e que, caso aceitas e cumpridas, geram receita para o parceiro.",
                            ),
                            Questions(
                              title:
                                  "Fiz o cadastro, enviei as fotos, assisti à apresentação online e ainda não fui ativado. O que aconteceu?",
                              answer:
                                  """Se você realizou todos os procedimentos online, a sua ativação será concluída de acordo com a nossa demanda, para manter um equilíbrio entre o número de pedidos e a quantidade de motoristas parceiros ativos na plataforma na sua região.

Se este prazo passou e a ativação não ocorreu, duas situações podem ter ocorrido: a primeira é que havia alguma irregularidade com sua documentação, e a segunda é a ausência de documentos e/ou a observação “Exerce Atividade Remunerada” na sua CNH.

Em ambos os casos, você receberá mensagens tanto no e-mail, como no Whatsapp informando o problema e solicitando o reenvio. Fique tranquilo!
""",
                            ),
                            Questions(
                              title:
                                  "Como a MercadoExpresso funciona? Posso participar em meio período?",
                              answer:
                                  "A MercadoExpresso é uma plataforma que conecta fornecedores de produtos, a clientes que precisam de serviços relacionados à entrega. Como um Agente MercadoExpresso você pode escolher quando e quais entregas deseja fazer. ",
                            ),
                            Questions(
                              title:
                                  "O que preciso fazer durante o processo de registro?",
                              answer:
                                  "Após concluir seu cadastro, apenas fique de olho no aplicativo e em seu e-mail e aguarde. Nosso time de cadastro eventualmente solicita o reenvio de algumas fotos ou documentos.",
                            ),
                            Questions(
                              title: "Meus documentos estão seguros?",
                              answer:
                                  "As imagens de seus documentos são criptografadas com tecnologia de ponta e jamais serão compartilhadas. Fique tranquilo! ",
                            ),
                            Questions(
                              title:
                                  "Quais os requisitos necessários para a minha ativação com veículos de 2 rodas? ",
                              answer: """Para motos de placa cinza:

Os seguintes documentos atualizados:

- CNH com a observação EAR (Exerce Atividade Remunerada) ativa ou MEI com atividade relacionada a entregas;

- Um comprovante que informe os números da sua agência e conta bancária. Esse comprovante pode ser um cartão de débito ou de crédito, um extrato bancário ou até mesmo uma captura de tela do aplicativo do seu banco. A conta precisa estar no seu nome e você deve especificar se ela é corrente ou poupança no campo sinalizado;

- Documento da sua moto (CRLV).

- Veículo em perfeitas condições mecânicas (sem restrição de ano)

Para motos de placa vermelha:

Os seguintes documentos atualizados:

- CNH com a observação EAR (Exerce Atividade Remunerada) ativa ou MEI com atividade relacionada a entregas;

- Um comprovante que informe os números da sua agência e conta bancária. Esse comprovante pode ser um cartão de débito ou de crédito, um extrato bancário ou até mesmo uma captura de tela do aplicativo do seu banco. A conta precisa estar no seu nome e você deve especificar se ela é corrente ou poupança no campo sinalizado;

- Documento da sua moto (CRLV).

- Carteirinha do Condumoto (para motoristas do estado de São Paulo);

- Licença de motofrete.

- Veículo em perfeitas condições mecânicas (sem restrição de ano)

""",
                            ),
                            Questions(
                              title:
                                  "Quais os requisitos necessários para a minha ativação com veículos de 4 rodas?",
                              answer:
                                  """Você precisa ter um carro sedan, hatch, SUV, utilitário ou VUC fabricados em qualquer ano, desde que em perfeitas condições mecânicas.

 Além disso, você precisa dos seguintes documentos atualizados:

 - CNH com a observação EAR (Exerce Atividade Remunerada) ativa ou MEI com atividade relacionada a entregas;

 - Um comprovante que informe os números da sua agência e conta bancária. Esse comprovante pode ser um cartão de débito ou de crédito, um extrato bancário ou até mesmo uma captura de tela do aplicativo do seu banco. A conta precisa estar no seu nome e você deve especificar se ela é corrente ou poupança no campo sinalizado;

 - Documento do veículo (CRLV).

- Documento opcional: ANTT
""",
                            ),
                            Questions(
                              title:
                                  "Quais modelos de veículos são aceitos na plataforma?",
                              answer: """Motos
Carros (SUV, sedan e hatch)
Utilitários e similares
Vans e similares
Carretos e VUCs
""",
                            ),
                            Questions(
                              title:
                                  "Meu veículo não se encontra na lista, como posso ser um Agente na MercadoExpresso?",
                              answer:
                                  "A MercadoExpresso aceita veículos alugados ou em nome de terceiros. Você também pode tentar se registrar com seu veículo, mesmo que não esteja entre os listados. Quem sabe a gente não crie uma categoria para seu veículo no futuro.",
                            ),
                            Questions(
                              title:
                                  "Posso dirigir sem ser o dono de um veículo?",
                              answer:
                                  "Sim, não é necessário que o veículo esteja em seu nome.",
                            ),
                            Questions(
                              title:
                                  "Eu tenho diversos veículos, posso adicioná-los ao meu perfil de motorista?",
                              answer:
                                  "Sim, ao ficar online o Agente especifica quais de seus veículos estão disponíveis e, quando a missão for aceita, será especificado qual dos veículos disponíveis que deverá ser empregado para cumpri-la. ",
                            ),
                            Questions(
                              title:
                                  "Eu posso compartilhar o mesmo veículo com um amigo, cada um com sua conta?",
                              answer:
                                  "Sim, apenas atente-se que não é permitido atender a missões na MercadoExpresso com qualquer outro veículo além dos cadastrados em seu perfil. E quando um Agente estiver online com um veículo, o outro não conseguirá ficar online com o mesmo.",
                            ),
                            Questions(
                              title:
                                  "Posso ter o aplicativo em mais de um celular?",
                              answer: "Em breve.",
                            ),
                            Questions(
                              title:
                                  "A MercadoExpresso cobra algum tipo de taxa pela verificação da conta? Se sim, quanto?",
                              answer:
                                  "Não é cobrado nenhum valor pela ativação de sua conta!",
                            ),
                            Questions(
                              title:
                                  "Porque é necessário fazer um depósito de caução na ativação? O dinheiro depositado pode ser recuperado depois?",
                              answer:
                                  "A taxa de caução te protege em casos de quebras acidentais enquanto trabalha conosco! Este depósito é feito apenas na ativação. A única condição em que é cobrado novamente é, se precisarmos repor alguma coisa que quebre durante uma entrega que você faz conosco. A taxa é devolvida ao Agente quando ele decidir encerrar a parceria com a plataforma.",
                            ),
                            Questions(
                              title:
                                  "Ao me cadastrar eu me torno um funcionário da MercadoExpresso?",
                              answer:
                                  "Não, você se tornará um Agente parceiro, sem vínculo ou qualquer tipo de relação trabalhista com a MercadoExpresso",
                            ),
                            Questions(
                              title:
                                  "Como consigo um baú ou uma bag da MercadoExpresso?",
                              answer:
                                  "Existem duas possibilidades: adquirir conosco ou ser premiado com um desses itens. Para adquirir, entre em contato com nosso suporte e verifique o procedimento e a disponibilidade. Já para ser premiado, faça muitas corridas com a gente e mantenha sua nota alta. Periodicamente, nós fazemos eventos para presentear os parceiros. Se você continuar entregando com comprometimento e qualidade, pode ter certeza: você também será premiado!",
                            ),
                            Questions(
                              title:
                                  "Quais as diferenças entre ser um agente com placa cinza ou placa vermelha?",
                              answer:
                                  """Na categoria de placa cinza o Agente não tem licença como motofrete e Condumoto. Os pedidos da categoria placa cinza têm valores um pouco menores. 

Na categoria de placa vermelha o Agente é profissional e tem licenças como motofrete e Condumoto. As mercadorias são transportadas em baús e os pedidos têm valores um pouco maiores.
""",
                            ),
                            Questions(
                              title:
                                  "Posso ser um Agente da MercadoExpresso e continuar entregando com outras empresas?",
                              answer:
                                  "Sim. Você tem a liberdade para entregar com outras empresas. No entanto, pedimos que em hipótese alguma você aceite dois pedidos de apps diferentes ao mesmo tempo. Para a MercadoExpresso, respeitar o prazo de entrega é fundamental, e situações assim podem comprometer a qualidade do serviço prestado, e consequentemente afetar sua reputação na plataforma.",
                            ),
                            Questions(
                              title:
                                  "Quantos dias leva para eu começar a lucrar com o aplicativo?",
                              answer:
                                  "Assim que sua conta é ativada, você começa a receber notificações de serviço e já começa a construir sua renda.",
                            ),
                            Questions(
                              title:
                                  "Quanto eu posso ganhar por semana com a MercadoExpresso?",
                              answer:
                                  "Todas as categorias de veículos tem ótimas possibilidades de ganhos, dependendo apenas da frequência do Agente na plataforma e da demanda de entregas, que cresce todos os dias em todas as regiões que atendemos. Seus ganhos são fixos e determinados por distância percorrida e serviços extras contratados.",
                            ),
                            Questions(
                              title:
                                  "Após a Verificação, como posso sacar meus ganhos?",
                              answer:
                                  """Para sacar o seu dinheiro, faça o seguinte:
Clique na sua foto para acessar o menu “Conta”;
Selecione a opção “Minha Carteira” para visualizar seus ganhos;
Verifique seu saldo e em seguida clique em “Sacar”
Insira o valor que deseja sacar e em seguida clique em “Confirmar”.
Pronto! Agora é só aguardar o valor cair na sua conta!
Não se esqueça de que é preciso ter uma Conta ou poupança em seu nome para efetuar o pedido de saque. Você pode especificar um saque de todo o valor disponível ou de uma fração dele. 

Solicitações feitas até 23h59 de domingo são depositadas até quinta-feira da mesma semana.
""",
                            ),
                            Questions(
                              title:
                                  "Meu repasse não foi transferido para minha conta bancária. Como devo proceder?",
                              answer:
                                  "Caso o seu repasse não caia em sua conta bancária até quinta-feira após a sua solicitação, a MercadoExpresso vai entrar em contato com você para solucionar eventuais problemas. Pode ficar tranquilo!",
                            ),
                            Questions(
                              title:
                                  "Preciso emitir nota para a MercadoExpresso?",
                              answer:
                                  "Não! A MercadoExpresso apenas intermedia a relação entre os serviços de entrega e os Agentes parceiros. Por isso não precisamos de nota fiscal.",
                            ),
                            Questions(
                              title:
                                  "Recebo alguma nota fiscal da MercadoExpresso?",
                              answer:
                                  "Não, mas por meio do aplicativo você pode ver todo o histórico das suas transações.",
                            ),
                            Questions(
                              title:
                                  "A MercadoExpresso cobra algum tipo de comissão dos Agentes parceiros?",
                              answer:
                                  "Sim, cobramos uma comissão sobre as missões na plataforma. Com ela podemos oferecer um melhor suporte para você, assim como conseguimos oferecer um aplicativo estável e com melhoria contínua..",
                            ),
                            Questions(
                              title:
                                  "Quando eu recebo uma notificação de Missão, o valor aparece com ou sem comissão?",
                              answer:
                                  "Ao receber uma notificação de missão disponível, você verá o valor líquido do serviço, já descontada a comissão da MercadoExpresso.",
                            ),
                            Questions(
                              title:
                                  "Devo emitir nota fiscal para a MercadoExpresso?",
                              answer:
                                  "Não é necessário emitir uma nota fiscal. A MercadoExpresso é uma empresa intermediadora do serviço de entrega entre os clientes solicitantes e os clientes Agentes. Portanto, emitimos uma nota fiscal para o cliente solicitante com os valores referentes à comissão pelo uso da plataforma.",
                            ),
                            Questions(
                              title:
                                  "Recebo alguma nota fiscal da MercadoExpresso?",
                              answer:
                                  """Sim, você recebe uma NFS-e (Nota Fiscal de Serviços Eletrônica) a cada mês referente à comissão para a MercadoExpresso.

A emissão da NFS-e é realizada até o dia 15 (quinze) de cada mês. O link da nota eletrônica e o boleto são enviados através do remetente fiscal@mercadoexpresso.com.br diretamente para o seu e-mail cadastrado na plataforma.""",
                            ),
                            Questions(
                              title:
                                  "Como baixar o aplicativo da MercadoExpresso?",
                              answer:
                                  "Caso seu celular seja Android, basta acessar a Play Store e procurar pelo aplicativo MercadoExpresso Para Agentes. Se você tiver um iPhone, faça a mesma coisa na App Store. Nosso app tem um ícone com um alien entregador.",
                            ),
                            Questions(
                              title:
                                  "Quais os equipamentos necessários para realizar Missões de entregas com motos?",
                              answer:
                                  """Antes de tudo, a MercadoExpresso prioriza a sua segurança. Por isso, assim que você estiver habilitado na nossa plataforma e pronto para começar a atender a Missões de entregas, certifique-se que você esteja com o equipamento necessário - o capacete é essencial para a sua integridade física. Você também precisa de uma bag (ou baú, no caso da categoria placa vermelha) para transportar o produto.
Com tudo pronto e depois que seu cadastro for ativado, basta abrir o aplicativo “MercadoExpresso para Agentes” e começar a cumprir missões.
""",
                            ),
                            Questions(
                              title: "Como ficar online e offline no app?",
                              answer:
                                  "Na primeira tela do app, você decide se está online e disponível para fazer entregas, ou se prefere ficar offline e, portanto, indisponível. Ao ficar online você pode indicar quais dos veículos associados a você estão disponíveis no momento para atender a Missões.",
                            ),
                            Questions(
                              title:
                                  "Como são as notificações de entrega do app?",
                              answer:
                                  """Quando uma nova Missão chegar, você ouvirá um som de “Missão Secreta” e uma janela aparecerá com informações sobre o serviço. Quando o pedido se tratar de uma entrega, será mostrado o bairro de coleta e retirada do pedido, o veículo a ser empregado, o valor, a forma de pagamento e quando a entrega deverá ser feita.

Atualmente, todos os pedidos devem ser atendidos de imediato, ou seja, assim que o parceiro aceitar o pedido. Mas futuramente outras modalidades serão acrescentadas.
""",
                            ),
                            Questions(
                              title:
                                  "Devo seguir o trajeto que está no aplicativo?",
                              answer:
                                  "A MercadoExpresso sabe que os Agentes parceiros são os que mais conhecem as ruas da cidade - afinal, é nas ruas que vocês trabalham todo dia! Entretanto, nosso aplicativo calcula a rota de menor tempo até os endereços de coleta e entrega. Por isso, recomendamos que você use o GPS, já que o valor da corrida é calculado com base nessa rota. Além disso, como tanto o cliente como a MercadoExpresso conseguem acompanhar sua localização em tempo real, é melhor seguir o caminho estipulado pelo GPS.",
                            ),
                            Questions(
                              title:
                                  "Como proceder para retirar o pedido com o Fornecedor?",
                              answer:
                                  "Ao chegar ao local de coleta, identifique-se ao Fornecedor que irá validar sua identidade através de sua fotografia e do token de verificação. Informe o seu token corretamente para que o Fornecedor valide-o em seu aplicativo. Quando o token for validado o pedido o status do pedido será atualizado na plataforma, tornando-se visível inclusive para o cliente como Retirado. Tire algumas fotografias do pacote como evidência e atualize no campo solicitado em seu aplicativo, em seguida se dirija ao local de entrega.",
                            ),
                            Questions(
                              title:
                                  "Como proceder para entregar o pedido para o Cliente?",
                              answer:
                                  """Ao chegar ao local de entrega, confira as instruções de entrega e certifique-se de segui-las apropriadamente para localizar o Cliente. Se for necessário utilize o chat para falar com ele e facilitar o encontro de vocês. Inclusive você poderá tirar fotos de onde está e subir como anexo na conversa com o objetivo de agilizar o processo de encontro.

Geralmente o cliente estará lá para receber a entrega, mas pode ser que ele peça para alguém receber em seu lugar. Em qualquer caso será necessário solicitar o código de verificação do cliente para validar se quem está recebendo o pedido de fato é uma pessoa autorizada. Ao receber o token do cliente, digite-o no campo apropriado em seu aplicativo e apenas entregue a encomenda se o aplicativo informar que o token é válido. Neste caso a missão será atualizada com o status Concluída e você estará liberado para atender novas missões. Caso o destinatário não disponha de um token válido, entre em contato com o suporte da MercadoExpresso através do chat do seu aplicativo que dentro de instantes você receberá as instruções de como proceder.
""",
                            ),
                            Questions(
                              title:
                                  "O Cliente mora em um condomínio. Preciso subir até a porta do apartamento para entregar em mãos?",
                              answer:
                                  """Se for um condomínio horizontal e estiver autorizado pelo cliente, o procedimento padrão é seguir até a residência do Cliente para encontrá-lo e entregar em mãos, a menos que ele passe o token para o porteiro e solicite que a encomenda seja deixada na portaria. 

No entanto, para condomínios verticais, o procedimento padrão é encontrar o cliente na portaria e realizar a entrega lá mesmo. A exceção é quando o cliente contratou um serviço adicional para entrega na porta. Neste caso, quando você aceita a Missão, se compromete a cumprir as instruções de entrega fornecidas pelo cliente apropriadamente, tendo, por exemplo, que se dirigir à sua residência caso seja necessário.
""",
                            ),
                            Questions(
                              title: "Como agir se a sua carga for roubada?",
                              answer:
                                  """É importante frisar que a sua segurança e bem-estar são o que realmente importam nesse tipo de situação. Por isso, antes de fazer qualquer coisa, certifique-se de estar em um local seguro. Depois disso, siga os passos a seguir:

Caso você não esteja bem fisicamente, dirija-se primeiro ao hospital mais próximo. Somente depois de ficar bem, continue as próximas etapas;
Se você estiver bem fisicamente, dirija-se à delegacia mais próxima e faça um boletim de ocorrência. Após isso, envie uma foto do documento para a gente através do suporte pelo aplicativo ou email suporte@mercadoexpresso.com.br.""",
                            ),
                            Questions(
                              title:
                                  "Se eu suspeitar que estou com uma carga ilícita, como devo agir?",
                              answer:
                                  "Caso você esteja em uma missão e desconfie que o item entregue pelo Fornecedor seja ilícito, sugerimos que você vá até a delegacia mais próxima e faça um boletim de ocorrência. Com o documento em mãos, entre em contato conosco pelo suporte do seu aplicativo e envie a foto do boletim.",
                            ),
                            Questions(
                              title:
                                  "Posso fazer mais de uma entrega ao mesmo tempo?",
                              answer:
                                  "Não. Nós da MercadoExpresso queremos oferecer o melhor serviço possível para os nossos clientes. Por isso, os Agentes parceiros fazem uma entrega de cada vez. Assim, há um maior cuidado com o pedido. Além disso, com os parceiros fazendo apenas um serviço por vez, conseguimos distribuir nossas Missões de forma mais igualitária e beneficiamos um número maior de Agentes.",
                            ),
                            Questions(
                              title:
                                  "Preciso entrar em contato com a MercadoExpresso, como proceder?",
                              answer:
                                  "Fale com a gente enviando uma mensagem pelo suporte do aplicativo ou através do email suporte@mercadoexpresso.com.br.",
                            ),
                            Questions(
                              title:
                                  "Não posso fazer a entrega que peguei. E agora?",
                              answer:
                                  "Um dos diferenciais da MercadoExpresso está no fato de apresentarmos todas as informações sobre os pedidos ao enviar as Missões para os nossos parceiros. Por isso, só aceite as missões que você realmente puder fazer. O cancelamento de uma Missão é feito apenas em situações emergenciais. Caso tenha alguma dúvida, fale com a gente pelo suporte do aplicativo ou através do email suporte@mercadoexpresso.com.br.",
                            ),
                            Questions(
                              title:
                                  "Posso ser selecionado para um pedido específico?",
                              answer:
                                  "O principal critério para uma Missão aparecer em seu aplicativo é a geolocalização, ou seja: o Agente (favoritado ou não) precisa estar sempre próximo do ponto de retirada para receber a notificação da Missão. A geolocalização é utilizada pelo usuário para acompanhar o seu pedido na plataforma.",
                            ),
                            Questions(
                              title:
                                  "Caso não consiga realizar a entrega de algum pacote, o que fazer?",
                              answer:
                                  """Em algumas situações, não será possível realizar a entrega - o destinatário pode estar ausente, por exemplo, dentre outras variáveis. Caso isso ocorra, a MercadoExpresso acionará o cliente para informar sobre o ocorrido e buscar uma solução. A ação a ser tomada dependerá do remetente atender ou não o nosso contato. Entenda nosso curso de ação abaixo: 
Cliente atendo ao contato: pediremos um endereço de sua escolha para encaminhar o produto;
Cliente não atende ao contato: o produto será encaminhado para o ponto de origem do pedido.

Caso o Fornecedor não receba o produto no endereço de origem, vamos levar em consideração se o produto é perecível (alimentos prontos, por exemplo) ou não. Com base nisso, o Agente parceiro será orientado a fazer o seguinte:

Produto perecível: o item será descartado;
Produto não-perecível: o item será transportado a um endereço designado pela MercadoExpresso. Nós aguardaremos o contato do cliente para encaminhá-lo a um ponto escolhido pelo cliente, mediante custos adicionais.
""",
                            ),
                            Questions(
                              title:
                                  "Os agentes parceiros da MercadoExpresso têm algum seguro?",
                              answer: "Em breve.",
                            ),
                            Questions(
                              title:
                                  "Quais são meus direitos como Agente parceiro?",
                              answer:
                                  "É importante que você leia nossos Termos e Condições. Lá você encontrará informações importantes sobre seus direitos, responsabilidades, detalhes sobre repasses, dentre outras coisas importantes.",
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: wXD(100, context)),
                  ],
                ),
              ),
              AnimatedPositioned(
                duration: Duration(milliseconds: 300),
                curve: Curves.ease,
                right:
                    mainStore.visibleNav ? wXD(16, context) : wXD(-60, context),
                bottom: wXD(100, context),
                child: GestureDetector(
                  onTap: () {
                    print('onTap');
                    Modular.to.pushNamed('/support-chat');
                  },
                  child: Container(
                    height: wXD(56, context),
                    width: wXD(56, context),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: getColors(context).surface,
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 3,
                          offset: Offset(0, 3),
                          color: getColors(context).shadow,
                        ),
                      ],
                    ),
                    alignment: Alignment.center,
                    child: Icon(
                      Icons.support_agent,
                      color: getColors(context).onBackground,
                      size: wXD(35, context),
                    ),
                  ),
                ),
              ),
              DefaultAppBar("Suporte", noPop: true),
            ],
          );
        },
      ),
    );
  }
}

class Questions extends StatefulWidget {
  final String title;
  final String answer;
  const Questions({Key? key, required this.title, required this.answer})
      : super(key: key);

  @override
  State<Questions> createState() => _QuestionsState();
}

class _QuestionsState extends State<Questions> {
  bool visible = false;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () => setState(() => visible = !visible),
          child: Container(
            alignment: Alignment.bottomCenter,
            // height: wXD(20, context),
            child: Column(
              children: [
                SizedBox(height: wXD(7, context)),
                Row(
                  children: [
                    Container(
                      width: wXD(305, context),
                      child: Text(
                        widget.title,
                        style: textFamily(
                          context,
                          fontSize: 12,
                          color:
                              getColors(context).onBackground.withOpacity(.9),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Spacer(),
                    Transform.rotate(
                      angle: visible ? math.pi / -2 : math.pi / 2,
                      child: Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: wXD(15, context),
                        color: getColors(context).primary,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: wXD(7, context)),
              ],
            ),
          ),
        ),
        Visibility(
          visible: visible,
          child: Container(
            child: Text(
              widget.answer,
              style: textFamily(
                context,
                fontSize: 11,
                fontWeight: FontWeight.w400,
                color: getColors(context).onBackground.withOpacity(.9),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
