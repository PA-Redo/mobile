import 'package:flutter/material.dart';
import 'package:pa_mobile/core/model/address/address_dto.dart';
import 'package:pa_mobile/core/model/local_unit/local_unit_response_dto.dart';
import 'package:pa_mobile/core/model/volonteer/volunteer_response_dto.dart';
import 'package:pa_mobile/flows/account/logic/account.dart';
import 'package:pa_mobile/flows/account/ui/modify_profile_screen.dart';
import 'package:pa_mobile/flows/home/ui/home_screen.dart';
import 'package:pa_mobile/shared/services/storage/jwt_secure_storage.dart';
import 'package:pa_mobile/shared/services/storage/secure_storage.dart';
import 'package:pa_mobile/shared/services/storage/stay_login_secure_storage.dart';
import 'package:pa_mobile/shared/widget/disable_focus_node.dart';

class AccountScreenVolunteer extends StatefulWidget {
  const AccountScreenVolunteer({super.key});

  static const routeName = '/profile_volunteer';

  @override
  State<AccountScreenVolunteer> createState() => _AccountScreenVolunteerState();
}

class _AccountScreenVolunteerState extends State<AccountScreenVolunteer> {
  VolunteerResponseDto volunteerResponseDto = VolunteerResponseDto(
    1,
    'loading',
    'loading',
    'loading',
    'loading',
    false,
    0,
  );

  LocalUnitResponseDTO localUnit = LocalUnitResponseDTO(
    0,
    'loading',
    AddressDTO(
      'loading',
      'loading',
      'loading',
      'loading',
    ),
    'loading',
    'loading',
  );

  int _screenIndex = 0;
  String title = 'Profile';

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final volunteer = await Account.getVolunteerInfo();
    final localUnitResponse = await Account.getLocalUnit(volunteer.localUnitId.toString());

    setState(() {
      volunteerResponseDto = volunteer;
      localUnit = localUnitResponse;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(
          title,
          style: Theme.of(context).textTheme.headlineLarge,
        ),
      ),
      body: getBody(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _screenIndex,
        onTap: _onNavigationChanged,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Theme.of(context).colorScheme.tertiary,
        unselectedItemColor: Theme.of(context).colorScheme.secondary,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'Chat',
          ),
        ],
      ),
    );
  }

  Widget getBody() {
    if (_screenIndex == 0) {
      return getProfile();
    } else if (_screenIndex == 1) {
      return const Text('Chat');
    } else {
      return const Text('Error');
    }
  }

  Widget getProfile() {
    return SingleChildScrollView(
      child: FutureBuilder(
        future: Future.value(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            JwtSecureStorage().deleteJwtToken();
            StayLoginSecureStorage().notStayLogin();
            Navigator.pushNamedAndRemoveUntil(
              context,
              HomeScreen.routeName,
                  (route) => false,
            );
            return Container();
          } else {
            return SafeArea(
              child: Column(
                children: [
                  SingleChildScrollView(
                    child: Row(
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(15),
                          child: Icon(Icons.account_circle, size: 80),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(bottom: 2),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    'Bonjour',
                                    style: Theme.of(context).textTheme.bodySmall,
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 2),
                              child: Text(
                                '${volunteerResponseDto.firstName} ${volunteerResponseDto.lastName}',
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                        RawMaterialButton(
                          onPressed: () async {
                            await Navigator.pushNamed(
                              context,
                              ModifyProfileScreen.routeName,
                              arguments: volunteerResponseDto,
                            );
                            _loadData();
                          },
                          fillColor: Theme.of(context).colorScheme.secondary,
                          padding: const EdgeInsets.all(10),
                          shape: const CircleBorder(),
                          child: const Icon(
                            Icons.edit,
                            size: 20,
                            color: Colors.white,
                          ),
                        ),
                        const Padding(padding: EdgeInsets.only(right: 0)),
                        RawMaterialButton(
                          onPressed: () {
                            JwtSecureStorage().deleteJwtToken();
                            StayLoginSecureStorage().notStayLogin();
                            Navigator.pushNamedAndRemoveUntil(
                              context,
                              HomeScreen.routeName,
                                  (route) => false,
                            );
                          },
                          shape: const CircleBorder(),
                          fillColor: Theme.of(context).colorScheme.secondary,
                          padding: const EdgeInsets.all(10.0),
                          child: const Icon(
                            Icons.logout,
                            size: 20,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 30, right: 30),
                    child: Column(
                      children: [
                        TextField(
                          decoration: const InputDecoration(
                            icon: Icon(Icons.email),
                            labelText: 'Email',
                          ),
                          readOnly: true,
                          controller: TextEditingController(
                            text: volunteerResponseDto.username,
                          ),
                          focusNode: AlwaysDisabledFocusNode(),
                        ),
                        TextField(
                          decoration: const InputDecoration(
                            icon: Icon(Icons.person),
                            labelText: 'Nom',
                          ),
                          readOnly: true,
                          controller: TextEditingController(
                            text:
                            '${volunteerResponseDto.lastName} ${volunteerResponseDto.firstName}',
                          ),
                          focusNode: AlwaysDisabledFocusNode(),
                        ),
                        TextField(
                          decoration: const InputDecoration(
                            icon: Icon(Icons.phone),
                            labelText: 'Numéro de téléphone',
                          ),
                          readOnly: true,
                          controller: TextEditingController(
                            text: volunteerResponseDto.phoneNumber,
                          ),
                          focusNode: AlwaysDisabledFocusNode(),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20, bottom: 20),
                    child: Divider(
                      color: Theme.of(context).colorScheme.secondary,
                      thickness: 1,
                      indent: 30,
                      endIndent: 30,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 30, right: 30),
                    child: Column(
                      children: [
                        TextField(
                          decoration: const InputDecoration(
                            icon: Icon(Icons.account_balance_outlined),
                            labelText: 'Unité locale',
                          ),
                          readOnly: true,
                          controller: TextEditingController(
                            text: localUnit.name,
                          ),
                          focusNode: AlwaysDisabledFocusNode(),
                        ),
                        TextField(
                          decoration: const InputDecoration(
                            icon: Icon(Icons.location_on),
                            labelText: 'Adresse',
                          ),
                          readOnly: true,
                          controller: TextEditingController(
                            text:
                            '${localUnit.address.city}, ${localUnit.address.streetNumberAndName}',
                          ),
                          focusNode: AlwaysDisabledFocusNode(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  void _onNavigationChanged(int index) {
    setState(() {
      _screenIndex = index;
      if (_screenIndex == 0) {
        title = 'Profile';
      } else if (_screenIndex == 1) {
        title = 'Chat';
      } else {
        title = 'Error';
      }
    });
  }
}
