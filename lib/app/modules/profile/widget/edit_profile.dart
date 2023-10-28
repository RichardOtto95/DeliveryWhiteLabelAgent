import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delivery_agent_white_label/app/core/models/time_model.dart';
import 'package:delivery_agent_white_label/app/shared/utilities.dart';
// import 'package:delivery_agent_white_label/app/shared/widgets/center_load_circular.dart';
import 'package:delivery_agent_white_label/app/shared/widgets/default_app_bar.dart';
import 'package:delivery_agent_white_label/app/shared/widgets/side_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import '../profile_store.dart';
import 'profile_data_tile.dart';

class EditProfile extends StatefulWidget {
  EditProfile({Key? key}) : super(key: key);

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final TextEditingController pixEditController = TextEditingController();
  final ScrollController scrollController = ScrollController();
  final ProfileStore store = Modular.get();
  final Masks masks = Masks();

  final _formKey = GlobalKey<FormState>();
  final genderKey = GlobalKey();
  final bankKey = GlobalKey();

  final LayerLink genderLayerLink = LayerLink();
  final LayerLink bankLayerLink = LayerLink();
  final LayerLink pixLayerLink = LayerLink();

  late OverlayEntry genderOverlay;
  late OverlayEntry bankOverlay;
  late OverlayEntry pixOverlay;
  late OverlayEntry loadOverlay;

  TextEditingController bankTextController = TextEditingController();

  MaskTextInputFormatter? _pixMask;

  FocusNode usernameFocus = FocusNode();
  FocusNode fullnameFocus = FocusNode();
  FocusNode birthdayFocus = FocusNode();
  FocusNode cpfFocus = FocusNode();
  FocusNode phoneFocus = FocusNode();
  FocusNode rgFocus = FocusNode();
  FocusNode issuingAgencyFocus = FocusNode();
  FocusNode genderFocus = FocusNode();
  FocusNode cnpjFocus = FocusNode();
  FocusNode bankFocus = FocusNode();
  FocusNode agencyFocus = FocusNode();
  FocusNode agencyDigitFocus = FocusNode();
  FocusNode accountFocus = FocusNode();
  FocusNode accountDigitFocus = FocusNode();
  FocusNode digitFocus = FocusNode();
  FocusNode operationFocus = FocusNode();
  FocusNode pixKeyFocus = FocusNode();
  FocusNode pixFocus = FocusNode();
  // FocusNode openingHoursFocus = FocusNode();
  // FocusNode descriptionFocus = FocusNode();
  // FocusNode categoryFocus = FocusNode();

  bool emailPix = false;

  @override
  void initState() {
    store.profileEdit = store.profileData;
    _pixMask = masks.nothingMask;
    setPixMask();
    addGenderFocusListener();
    addBirthdayFocusListener();
    addBankFocusListener();
    addPixKeyFocusListener();
    super.initState();
  }

  @override
  void dispose() {
    fullnameFocus.dispose();
    birthdayFocus.dispose();
    cpfFocus.dispose();
    phoneFocus.dispose();
    rgFocus.dispose();
    issuingAgencyFocus.dispose();
    genderFocus.dispose();
    bankFocus.dispose();
    agencyFocus.dispose();
    agencyDigitFocus.dispose();
    accountFocus.dispose();
    accountDigitFocus.dispose();
    digitFocus.dispose();
    operationFocus.dispose();
    pixKeyFocus.dispose();
    pixFocus.dispose();
    // cnpjFocus.dispose();
    // openingHoursFocus.dispose();
    // descriptionFocus.dispose();
    // categoryFocus.dispose();

    super.dispose();
  }

  Future scrollToGender() async {
    final _context = genderKey.currentContext;
    double proportion = hXD(73, context) / maxWidth(context);
    await Scrollable.ensureVisible(_context!,
        alignment: proportion, duration: const Duration(milliseconds: 400));
  }

  Future scrollToBank() async {
    final _context = bankKey.currentContext;
    double proportion = hXD(73, context) / maxWidth(context);
    await Scrollable.ensureVisible(_context!,
        alignment: proportion, duration: const Duration(milliseconds: 400));
  }

  addGenderFocusListener() {
    genderFocus.addListener(() async {
      if (genderFocus.hasFocus) {
        scrollToGender();
        genderOverlay = getGenderOverlay();
        Overlay.of(context)!.insert(genderOverlay);
      } else {
        genderOverlay.remove();
      }
    });
  }

  addBirthdayFocusListener() {
    birthdayFocus.addListener(() async {
      if (birthdayFocus.hasFocus) {
        await store.setBirthday(
          context,
          () {
            cpfFocus.requestFocus();
          },
        );
      }
    });
  }

  addPixKeyFocusListener() {
    pixKeyFocus.addListener(() async {
      if (pixKeyFocus.hasFocus) {
        pixOverlay = getPixKeyOverlay();
        Overlay.of(context)!.insert(pixOverlay);
        scrollController.animateTo(scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 500), curve: Curves.ease);
      } else {
        pixOverlay.remove();
      }
    });
  }

  addBankFocusListener() {
    bankFocus.addListener(() async {
      if (bankFocus.hasFocus) {
        scrollToBank();
        bankOverlay = getBankOverlay();
        Overlay.of(context)!.insert(bankOverlay);
      } else {
        bankOverlay.remove();
      }
    });
  }

  OverlayEntry getGenderOverlay() {
    List<String> genders = ["Feminino", "Masculino", "Outro"];
    return OverlayEntry(
      builder: (context) => Positioned(
        height: wXD(100, context),
        width: wXD(80, context),
        child: CompositedTransformFollower(
          offset: Offset(wXD(35, context), wXD(60, context)),
          link: genderLayerLink,
          child: Material(
            color: Colors.transparent,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(3),
                  bottomLeft: Radius.circular(3),
                ),
                color: getColors(context).surface,
                boxShadow: [
                  BoxShadow(
                      blurRadius: 3,
                      offset: const Offset(0, 3),
                      color: getColors(context).shadow)
                ],
              ),
              alignment: Alignment.center,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: genders
                    .map(
                      (gender) => InkWell(
                        onTap: () {
                          store.profileEdit['gender'] = gender;
                          store.profileData['gender'] = gender;
                          bankFocus.requestFocus();
                        },
                        child: Container(
                          height: wXD(20, context),
                          padding: EdgeInsets.only(left: wXD(8, context)),
                          alignment: Alignment.centerLeft,
                          child: Text(
                            gender,
                            style: textFamily(
                              context,
                              color: getColors(context).onSurface,
                            ),
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Map<String, String> pixKeys = {
    "CPF/CNPJ": "CPF/CNPJ",
    "PHONE": "Celular",
    "EMAIL": "E-mail",
    "RANDOM": "Aleatória",
  };

  OverlayEntry getPixKeyOverlay() {
    return OverlayEntry(
      builder: (context) => Positioned(
        height: wXD(100, context),
        width: wXD(80, context),
        child: CompositedTransformFollower(
          offset: Offset(wXD(35, context), wXD(60, context)),
          link: pixLayerLink,
          child: Material(
            color: Colors.transparent,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(3),
                  bottomLeft: Radius.circular(3),
                ),
                color: getColors(context).surface,
                boxShadow: [
                  BoxShadow(
                      blurRadius: 3,
                      offset: const Offset(0, 3),
                      color: getColors(context).shadow)
                ],
              ),
              alignment: Alignment.center,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: pixKeys.keys
                    .map(
                      (key) => InkWell(
                        onTap: () {
                          print("$key: ${pixKeys[key]}");
                          store.profileEdit['pix_key'] = key;
                          store.profileData['pix_key'] = key;
                          emailPix = false;
                          setPixMask();
                          if (pixEditController.text != "") {
                            pixEditController.clear();
                          }
                          pixFocus.requestFocus();
                        },
                        child: Container(
                          height: wXD(20, context),
                          padding: EdgeInsets.only(left: wXD(8, context)),
                          alignment: Alignment.centerLeft,
                          child: Text(
                            pixKeys[key]!,
                            style: textFamily(
                              context,
                              color: getColors(context).onSurface,
                            ),
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void setPixMask() {
    print("pixKey: ${store.profileData["pix_key"]}");
    switch (store.profileData["pix_key"]) {
      case "CPF/CNPJ":
        if (_pixMask == null) {
          _pixMask = MaskTextInputFormatter(
              mask: '###.###.###-###', filter: {"#": RegExp(r'[0-9]')});
        } else {
          _pixMask!.updateMask(
            mask: "###.###.###-###",
            filter: {"#": RegExp(r'[0-9]')},
          );
        }
        break;
      case "PHONE":
        if (_pixMask == null) {
          _pixMask = masks.phoneMask;
        } else {
          _pixMask!.updateMask(
            mask: "(##) #####-####",
            filter: {"#": RegExp(r'[0-9]')},
          );
        }
        break;
      case "EMAIL":
        emailPix = true;
        _pixMask = null;
        break;
      case "RANDOM":
        _pixMask = null;
        break;
      default:
    }

    print("pix mask: ${_pixMask != null ? _pixMask!.getMask() : null}");
  }

  String? getPixData() {
    switch (store.profileData["pix_key"]) {
      case "Celular":
        return masks.phoneMask.maskText(store.profileData["pix"]);
      case "CPF/CNPJ":
        if (store.profileData["pix"].toString().length == 11) {
          return masks.cpfMask.maskText(store.profileData["pix"]);
        } else if (store.profileData["pix"].toString().length == 14) {
          return masks.cnpjMask.maskText(store.profileData["pix"]);
        }
        break;
      default:
        return store.profileData["pix"];
    }
  }

  OverlayEntry getBankOverlay() {
    if (store.bankDocs == null) {
      store.getBanks();
    }

    return OverlayEntry(
      maintainState: true,
      builder: (context) => Positioned(
        width: wXD(320, context),
        height: wXD(270, context),
        child: CompositedTransformFollower(
          offset: Offset(
            (maxWidth(context) - wXD(320, context)) / 2,
            wXD(80, context),
          ),
          link: bankLayerLink,
          child: Container(
            padding: EdgeInsets.all(wXD(5, context)),
            decoration: BoxDecoration(
              color: getColors(context).surface,
              boxShadow: [
                BoxShadow(
                  blurRadius: 6,
                  offset: Offset(0, 3),
                  color: getColors(context).shadow,
                )
              ],
            ),
            child: Material(
              color: getColors(context).surface,
              child: SingleChildScrollView(
                padding: EdgeInsets.all(wXD(5, context)),
                child: Observer(
                  builder: (context) {
                    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                      store.searchBank(bankTextController.text);
                    });
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        if (store.bankDocs == null)
                          Padding(
                            padding: EdgeInsets.only(top: wXD(100, context)),
                            child: Center(child: CircularProgressIndicator()),
                          ),
                        if (store.bankDocsSearch.isNotEmpty)
                          ...store.bankDocsSearch
                              .map(
                                (bank) => InkWell(
                                  onTap: () {
                                    bankTextController.text = bank.get("label");
                                    store.profileEdit['bank'] =
                                        bank.get("label");
                                    agencyFocus.requestFocus();
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      border: Border(
                                        bottom: BorderSide(
                                            color: getColors(context)
                                                .onSurface
                                                .withOpacity(.7),
                                            width: 1),
                                      ),
                                    ),
                                    padding: EdgeInsets.all(wXD(6, context)),
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      bank.get("label"),
                                      style: textFamily(
                                        context,
                                        color: getColors(context).onSurface,
                                      ),
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                        if (store.bankDocs != null &&
                            store.bankDocsSearch.isEmpty)
                          ...store.bankDocs!
                              .map(
                                (bank) => InkWell(
                                  onTap: () {
                                    bankTextController.text = bank.get("label");
                                    store.profileEdit['bank'] =
                                        bank.get("label");
                                    agencyFocus.requestFocus();
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      border: Border(
                                        bottom: BorderSide(
                                            color: getColors(context)
                                                .onSurface
                                                .withOpacity(.7),
                                            width: 1),
                                      ),
                                    ),
                                    padding: EdgeInsets.all(wXD(6, context)),
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      bank.get("label"),
                                      style: textFamily(
                                        context,
                                        color: getColors(context).onSurface,
                                      ),
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        store.profileEdit.clear();
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
          await store.setProfileEditFromDoc();
        });
        return true;
      },
      child: Scaffold(
        body: Stack(
          children: [
            Observer(
              builder: (context) {
                // if (store.profileData.isEmpty) {
                //   return const CenterLoadCircular();
                // }
                // if (store.profileEdit.isEmpty) {
                //   WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                //     print("ProfileData: ${store.profileEdit["cpf"]}");
                //     store.profileEdit = store.profileData;
                //     setPixMask();
                //   });
                // }
                // print("ProfileData: ${store.profileData["username"]}");
                return SingleChildScrollView(
                  controller: scrollController,
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                            height: viewPaddingTop(context) + wXD(50, context)),
                        Stack(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.transparent,
                                boxShadow: [
                                  BoxShadow(
                                      blurRadius: 3,
                                      offset: const Offset(0, 3),
                                      color: getColors(context).shadow)
                                ],
                                borderRadius: const BorderRadius.only(
                                    bottomLeft: Radius.circular(3)),
                              ),
                              child: ClipRRect(
                                borderRadius: const BorderRadius.only(
                                    bottomLeft: Radius.circular(3)),
                                child: SizedBox(
                                  height: wXD(338, context),
                                  width: maxWidth(context),
                                  child: store.profileData['avatar'] != null
                                      ? CachedNetworkImage(
                                          imageUrl: store.profileData['avatar'],
                                          height: wXD(338, context),
                                          width: maxWidth(context),
                                          fit: BoxFit.fitWidth,
                                          progressIndicatorBuilder: (context,
                                              value, downloadProgress) {
                                            return Center(
                                              child: CircularProgressIndicator(
                                                color:
                                                    getColors(context).primary,
                                              ),
                                            );
                                          },
                                        )
                                      : store.profileEdit['avatar'] == null
                                          ? Image.asset(
                                              "./assets/images/defaultUser.png",
                                              height: wXD(338, context),
                                              width: maxWidth(context),
                                              fit: BoxFit.fitWidth,
                                            )
                                          : store.profileEdit['avatar'] == ""
                                              ? SizedBox(
                                                  height: wXD(338, context),
                                                  width: maxWidth(context),
                                                  child: Center(
                                                    child:
                                                        CircularProgressIndicator(
                                                      color: getColors(context)
                                                          .primary,
                                                    ),
                                                  ),
                                                )
                                              : CachedNetworkImage(
                                                  imageUrl: store
                                                      .profileEdit['avatar'],
                                                  height: wXD(338, context),
                                                  width: maxWidth(context),
                                                  fit: BoxFit.fitWidth,
                                                  progressIndicatorBuilder:
                                                      (context, value,
                                                          downloadProgress) {
                                                    return Center(
                                                      child:
                                                          CircularProgressIndicator(
                                                        color:
                                                            getColors(context)
                                                                .primary,
                                                      ),
                                                    );
                                                  },
                                                ),
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: wXD(30, context),
                              right: wXD(17, context),
                              child: InkWell(
                                onTap: () => store.pickAvatar(),
                                child: Icon(
                                  Icons.camera_alt,
                                  color: getColors(context).onSurface,
                                  size: wXD(30, context),
                                ),
                              ),
                            )
                          ],
                        ),
                        Visibility(
                          visible: store.avatarValidate,
                          child: Padding(
                            padding: EdgeInsets.only(
                                left: wXD(24, context), top: wXD(15, context)),
                            child: Text(
                              "Selecione uma imagem para continuar",
                              style: TextStyle(
                                color: Colors.red[600],
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            left: wXD(23, context),
                            top: wXD(21, context),
                          ),
                          child: Text(
                            'Dados pessoais',
                            style: textFamily(context,
                                fontSize: 16,
                                color: getColors(context).primary,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                        ProfileDataTile(
                          title: 'Nome de usuário',
                          data: store.profileEdit["username"] ??
                              store.profileData["username"],
                          focusNode: usernameFocus,
                          hint: "Seu nome de usuário",
                          onChanged: (val) {
                            store.profileEdit["username"] = val;
                          },
                          onComplete: () => fullnameFocus.requestFocus(),
                        ),
                        ProfileDataTile(
                          title: 'Nome completo',
                          data: store.profileEdit["fullname"] ??
                              store.profileData["fullname"],
                          focusNode: fullnameFocus,
                          hint: "Seu nome completo",
                          onChanged: (val) {
                            store.profileEdit["fullname"] = val;
                          },
                          onComplete: () {
                            birthdayFocus.requestFocus();
                          },
                        ),
                        ProfileDataTile(
                          title: 'Data de nascimento',
                          data: TimeModel().date(
                            store.profileEdit["birthday"] ??
                                store.profileData["birthday"],
                          ),
                          focusNode: birthdayFocus,
                          hint: "Sua data de nascimento",
                          onComplete: () => cpfFocus.requestFocus(),
                          onPressed: () {
                            store.setBirthday(
                              context,
                              () {
                                cpfFocus.requestFocus();
                              },
                            );
                          },
                          validate: store.birthdayValidate,
                        ),
                        ProfileDataTile(
                          title: 'CPF',
                          data: masks.cpfMask.maskText(
                            store.profileData["cpf"] ?? "",
                          ),
                          textInputType: TextInputType.number,
                          focusNode: cpfFocus,
                          hint: "Seu CPF",
                          mask: masks.cpfMask,
                          onChanged: (val) {
                            store.profileEdit["cpf"] = val;
                          },
                          onComplete: () => phoneFocus.requestFocus(),
                          length: 11,
                        ),
                        ProfileDataTile(
                          title: 'Telefone',
                          data: masks.fullNumberMask.maskText(
                            store.profileData["phone"] ?? "",
                          ),
                          hint: "Seu telefone",
                        ),
                        ProfileDataTile(
                          title: 'RG',
                          textInputType: TextInputType.number,
                          data: store.profileData["rg"] ?? "",
                          focusNode: rgFocus,
                          hint: "Seu RG",
                          onChanged: (val) {
                            store.profileEdit["rg"] = val;
                          },
                          onComplete: () => issuingAgencyFocus.requestFocus(),
                        ),
                        ProfileDataTile(
                          title: 'Órgão emissor',
                          // textCapitalization: TextCapitalization.characters,
                          data: store.profileEdit["issuing_agency"] ??
                              store.profileData["issuing_agency"],
                          inputFormatter: UpperCaseTextFormatter(),

                          focusNode: issuingAgencyFocus,
                          hint: "Seu órgão emissor",
                          onChanged: (val) {
                            store.profileEdit["issuing_agency"] = val;
                          },
                          onComplete: () => genderFocus.requestFocus(),
                        ),
                        CompositedTransformTarget(
                          link: genderLayerLink,
                          child: ProfileDataTile(
                            key: genderKey,
                            title: 'Gênero',
                            hint: 'Feminino',
                            data: store.profileEdit['gender'] ??
                                store.profileData['gender'],
                            focusNode: genderFocus,
                            validate: store.genderValidate,
                            onPressed: () {
                              genderFocus.requestFocus();
                            },
                          ),
                        ),
                        // ProfileDataTile(
                        //   title: 'CNPJ',
                        //   hint: '99.999.999/9999-99',
                        //   focusNode: cnpjFocus,
                        //   textInputType: TextInputType.number,
                        //   data: masks.cnpjMask
                        //       .maskText(store.profileData['cnpj'] ?? ''),
                        //   mask: masks.cnpjMask,
                        //   length: 14,
                        //   onComplete: () => openingHoursFocus.requestFocus(),
                        //   onChanged: (txt) => store.profileEdit['cnpj'] = txt,
                        // ),
                        // ProfileDataTile(
                        //   title: 'CNH',
                        //   hint: '0000',
                        //   focusNode: cnpjFocus,
                        //   keyboardType: TextInputType.number,
                        //   data: cnpjMask
                        //       .maskText(store.profileEdit['cnpj'] ?? ''),
                        //   mask: cnpjMask,
                        //   length: 14,
                        //   onComplete: () => openingHoursFocus.requestFocus(),
                        //   onChanged: (txt) => store.profileEdit['cnpj'] = txt,
                        // ),
                        // ProfileDataTile(
                        //   textInputType: TextInputType.number,
                        //   title: 'Horário de funcionamento',
                        //   hint: '14:00 às 16:00',
                        //   focusNode: openingHoursFocus,
                        //   data: masks.openingHoursMask.maskText(
                        //       store.profileData['opening_hours'] ?? ''),
                        //   mask: masks.openingHoursMask,
                        //   length: 8,
                        //   onComplete: () => descriptionFocus.requestFocus(),
                        //   onChanged: (txt) =>
                        //       store.profileEdit['opening_hours'] = txt,
                        // ),
                        // ProfileDataTile(
                        //   textInputType: TextInputType.number,
                        //   title: 'Descrição',
                        //   hint: 'Uso um capacete preto',
                        //   focusNode: descriptionFocus,
                        //   data: store.profileData['description'],
                        //   onComplete: () => categoryFocus.requestFocus(),
                        //   onChanged: (txt) =>
                        //       store.profileEdit['description'] = txt,
                        // ),
                        // ProfileDataTile(
                        //   textInputType: TextInputType.number,
                        //   title: 'Categoria',
                        //   hint: 'Entregas seguras e rápidas',
                        //   focusNode: categoryFocus,
                        //   data: store.profileData['category'],
                        //   onComplete: () => bankFocus.requestFocus(),
                        //   onChanged: (txt) =>
                        //       store.profileEdit['category'] = txt,
                        // ),
                        Padding(
                          padding: EdgeInsets.only(
                              left: wXD(23, context), top: wXD(21, context)),
                          child: Text(
                            'Dados Bancários',
                            style: textFamily(context,
                                fontSize: 16,
                                color: getColors(context).primary,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                        CompositedTransformTarget(
                          link: bankLayerLink,
                          child: ProfileDataTile(
                            key: bankKey,
                            title: 'Banco',
                            controller: bankTextController,
                            data: store.profileEdit['bank'],
                            onChanged: (txt) => store.searchBank(txt),
                            hint: 'Selecione seu banco',
                            focusNode: bankFocus,
                            // data2: "aleola",
                          ),
                        ),
                        ProfileDataTile(
                          title: 'Agência',
                          textInputType: TextInputType.number,
                          data: store.profileData["agency"],
                          focusNode: agencyFocus,
                          hint: "Sua agencia",
                          // mask: masks.agencyMask,
                          onChanged: (val) {
                            store.profileEdit["agency"] = val;
                          },
                          onComplete: () => agencyDigitFocus.requestFocus(),
                          data2: store.profileData["agency_digit"],
                          focusNode2: agencyDigitFocus,
                          hint2: "1",
                          onChanged2: (txt) =>
                              store.profileEdit["agency_digit"] = txt,
                          onComplete2: () => accountFocus.requestFocus(),
                        ),
                        ProfileDataTile(
                          title: 'Conta',
                          textInputType: TextInputType.number,
                          data: store.profileData["account"],

                          focusNode: accountFocus,
                          hint: "Sua conta",
                          // mask: masks.accountMask,
                          onChanged: (val) =>
                              store.profileEdit["account"] = val,
                          onComplete: () => accountDigitFocus.requestFocus(),
                          data2: store.profileData["account_digit"],
                          focusNode2: accountDigitFocus,
                          hint2: "1",
                          onChanged2: (txt) =>
                              store.profileEdit["account_digit"] = txt,
                          onComplete2: () => operationFocus.requestFocus(),
                        ),
                        ProfileDataTile(
                          title: 'Operação',
                          hint: '999',
                          textInputType: TextInputType.number,
                          data: masks.cpfMask.maskText(
                            store.profileEdit["operation"] ?? "",
                          ),
                          // data: store.profileEdit['operation'],
                          mask: masks.operationMask,
                          focusNode: operationFocus,
                          length: 3,
                          onComplete: () => pixKeyFocus.requestFocus(),
                          onChanged: (txt) =>
                              store.profileEdit['operation'] = txt,
                        ),
                        // ProfileDataTile(
                        //   title: 'Dígito',
                        //   textInputType: TextInputType.number,
                        //   data: masks.digitMask.maskText(
                        //     store.profileData["digit"] != null
                        //         ? store.profileData["digit"]
                        //         : "",
                        //   ),
                        //   focusNode: digitFocus,
                        //   hint: "Dígito da sua agência",
                        //   length: 1,
                        //   mask: masks.digitMask,
                        //   onChanged: (val) {
                        //     store.profileEdit["digit"] = val;
                        //   },
                        //   onComplete: () => pixKeyFocus.requestFocus(),
                        // ),
                        CompositedTransformTarget(
                          link: pixLayerLink,
                          child: ProfileDataTile(
                            title: 'Chave PIX',
                            data: pixKeys[store.profileData["pix_key"]],
                            focusNode: pixKeyFocus,
                            hint: "Seu tipo de chave pix",
                            onPressed: () => pixKeyFocus.requestFocus(),
                            onComplete: () => pixFocus.requestFocus(),
                            validate: store.pixKeyValidate,
                          ),
                        ),
                        ProfileDataTile(
                          title: 'PIX',
                          data: getPixData(),
                          focusNode: pixFocus,
                          hint: "Seu pix",
                          onChanged: (val) {
                            print("pix_key: ${store.profileEdit["pix_key"]}");
                            switch (store.profileEdit["pix_key"]) {
                              case "CPF/CNPJ":
                                if (val!.length >= 12) {
                                  _pixMask!
                                      .updateMask(mask: '##.###.###/####-##');
                                } else {
                                  if (_pixMask!.getMask() ==
                                      "##.###.###/####-##") {
                                    _pixMask!
                                        .updateMask(mask: '###.###.###-###');
                                  }
                                }
                                break;

                              case null:
                                switch (store.profileData["pix_key"]) {
                                  case "CPF/CNPJ":
                                    if (val!.length >= 12) {
                                      _pixMask!.updateMask(
                                          mask: '##.###.###/####-##');
                                    } else {
                                      if (_pixMask!.getMask() ==
                                          "##.###.###/####-##") {
                                        _pixMask!.updateMask(
                                            mask: '###.###.###-###');
                                      }
                                    }
                                    break;
                                  default:
                                }
                                break;
                              default:
                            }
                            store.profileEdit["pix"] = val;
                          },
                          controller: pixEditController,
                          onComplete: () => pixFocus.unfocus(),
                          mask: _pixMask,
                          textInputType:
                              store.profileData["pix_key"] != "EMAIL" &&
                                      store.profileData["pix_key"] != "RANDOM"
                                  ? TextInputType.number
                                  : null,
                          validator: (val) {
                            if (val == null) {
                              return "Este campo é obrigatório";
                            }
                            print("val: ${val.length}");
                            print(
                                "store.profileEdit[pix_key]: ${store.profileEdit["pix_key"]}");
                            print(
                                "store.profileData[pix_key]: ${store.profileData["pix_key"]}");
                            switch (store.profileEdit["pix_key"]) {
                              case "EMAIL":
                                bool emailValid = RegExp(
                                        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{3,}))$')
                                    .hasMatch(val);

                                if (!emailValid) {
                                  return 'Digite um e-mail válido!';
                                } else {
                                  return null;
                                }

                              case "CPF/CNPJ":
                                if (_pixMask!.getMask() == "###.###.###-###") {
                                  return val.length == 14
                                      ? null
                                      : "Digite o CPF corretamente!";
                                }
                                if (_pixMask!.getMask() ==
                                    "##.###.###/####-##") {
                                  return val.length == 18
                                      ? null
                                      : "Digite o CNPJ corretamente!";
                                }
                                break;

                              case "PHONE":
                                return val.length == 15
                                    ? null
                                    : "Digite o número de celular corretamente!";

                              case null:
                                switch (store.profileData["pix_key"]) {
                                  case "EMAIL":
                                    bool emailValid = RegExp(
                                            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{3,}))$')
                                        .hasMatch(val);

                                    if (!emailValid) {
                                      return 'Digite um e-mail válido!';
                                    } else {
                                      return null;
                                    }

                                  case "CPF/CNPJ":
                                    if (_pixMask!.getMask() ==
                                        "###.###.###-###") {
                                      return val.length == 14
                                          ? null
                                          : "Digite o CPF corretamente!";
                                    }
                                    if (_pixMask!.getMask() ==
                                        "##.###.###/####-##") {
                                      return val.length == 18
                                          ? null
                                          : "Digite o CNPJ corretamente!";
                                    }
                                    break;

                                  case "PHONE":
                                    return val.length == 11
                                        ? null
                                        : "Digite o número de celular corretamente!";

                                  default:
                                    return "Sem máscara";
                                }
                                break;

                              default:
                                return null;
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: wXD(30, context)),
                        SideButton(
                            onTap: () async {
                              bool _validate = store.getValidate();
                              print("validation1: $_validate ");
                              print(
                                  "validation2: ${_formKey.currentState!.validate()} ");
                              if (_formKey.currentState!.validate() &&
                                  _validate) {
                                await store.saveProfile(context);
                              } else {
                                showErrorToast(context,
                                    "Verifique os campos e tente novamente");
                              }
                            },
                            height: wXD(52, context),
                            width: wXD(142, context),
                            title: 'Salvar'),
                        SizedBox(height: wXD(20, context)),
                      ],
                    ),
                  ),
                );
              },
            ),
            DefaultAppBar(
              'Editar perfil',
              onPop: () async {
                store.profileEdit.clear();
                WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
                  await store.setProfileEditFromDoc();
                });
                Modular.to.pop();
              },
            )
          ],
        ),
      ),
    );
  }
}

class SavingsCNPJ extends StatelessWidget {
  const SavingsCNPJ({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: wXD(26, context),
        top: wXD(16, context),
        bottom: wXD(33, context),
      ),
      alignment: Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Esta é uma conta poupança?',
            style: textFamily(context,
                color: getColors(context).onBackground.withOpacity(.6)),
          ),
          SizedBox(height: wXD(10, context)),
          Row(
            children: [
              Container(
                height: wXD(17, context),
                width: wXD(17, context),
                margin: EdgeInsets.only(right: wXD(9, context)),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                      color: getColors(context).primary,
                      width: wXD(2, context)),
                ),
                alignment: Alignment.center,
              ),
              Text(
                'Sim',
                style: textFamily(context,
                    color: getColors(context).onBackground.withOpacity(.6)),
              ),
              Container(
                height: wXD(17, context),
                width: wXD(17, context),
                margin: EdgeInsets.only(
                    right: wXD(9, context), left: wXD(15, context)),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                      color: getColors(context).primary,
                      width: wXD(2, context)),
                ),
                alignment: Alignment.center,
                child: Container(
                  height: wXD(9, context),
                  width: wXD(9, context),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: getColors(context).primary,
                  ),
                ),
              ),
              Text(
                'Não',
                style: textFamily(context,
                    color: getColors(context).onBackground.withOpacity(.6)),
              ),
            ],
          ),
          SizedBox(height: wXD(24, context)),
          Text(
            'Esta conta bancária está vinculada ao CNPJ da \nloja?',
            style: textFamily(context,
                color: getColors(context).onBackground.withOpacity(.6)),
          ),
          SizedBox(height: wXD(10, context)),
          Row(
            children: [
              Container(
                height: wXD(17, context),
                width: wXD(17, context),
                margin: EdgeInsets.only(right: wXD(9, context)),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                      color: getColors(context).primary,
                      width: wXD(2, context)),
                ),
                alignment: Alignment.center,
              ),
              Text(
                'Sim',
                style: textFamily(context,
                    color: getColors(context).onBackground.withOpacity(.6)),
              ),
              Container(
                height: wXD(17, context),
                width: wXD(17, context),
                margin: EdgeInsets.only(
                    right: wXD(9, context), left: wXD(15, context)),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                      color: getColors(context).primary,
                      width: wXD(2, context)),
                ),
                alignment: Alignment.center,
                child: Container(
                  height: wXD(9, context),
                  width: wXD(9, context),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: getColors(context).primary,
                  ),
                ),
              ),
              Text(
                'Não',
                style: textFamily(context,
                    color: getColors(context).onBackground.withOpacity(.6)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
