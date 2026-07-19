import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class ProfileScreen extends StatelessWidget {

  const ProfileScreen({super.key});


  @override
  Widget build(BuildContext context) {


    User? currentUser =
        FirebaseAuth.instance.currentUser;



    return Scaffold(

      backgroundColor: Colors.white,


      body: StreamBuilder<DocumentSnapshot>(

        stream: FirebaseFirestore.instance
            .collection("users")
            .doc(currentUser!.uid)
            .snapshots(),


        builder:(context,snapshot){

  if(snapshot.connectionState == ConnectionState.waiting){

    return const Center(
      child:CircularProgressIndicator(),
    );

  }


  if(!snapshot.hasData || !snapshot.data!.exists){

    return const Center(
      child: Text(
        "Không tìm thấy dữ liệu Profile",
        style: TextStyle(
          fontSize:20,
          color:Colors.black,
        ),
      ),
    );

  }


final data =
snapshot.data!.data() as Map<String, dynamic>;



          return SingleChildScrollView(
            padding: EdgeInsets.only(bottom:100), //cách phía dưới
            child: Column(

              children:[


                const SizedBox(height:50),



                CircleAvatar(

                  radius:70,

                  backgroundColor:
                  Colors.grey.shade300,


                  child:

                  const Icon(

                    Icons.person,

                    size:80,

                    color:Colors.white,

                  ),

                ),



                const SizedBox(height:20),



                Text(
                  data["name"] ?.toString() ?? "Nike Member",
                  style: const TextStyle(
                    fontSize:32,
                    fontWeight:FontWeight.w500,
                  ),
                ),

                const SizedBox(height:8),

                Text(
                  data["email"] ?? "",
                  style: TextStyle(
                    fontSize:18,
                    color:Colors.grey,
                  ),
),

                const SizedBox(height:20),



                OutlinedButton(

                    onPressed:(){},

                    child:
                    const Text(
                      "Edit Profile",
                      style:
                      TextStyle(
                        color:Colors.black,
                        fontSize:18,
                      ),
                    )

                ),



                const SizedBox(height:40),



                Row(

                  mainAxisAlignment:
                  MainAxisAlignment.spaceAround,

                  children:[

                    menu(Icons.shopping_bag_outlined,
                        "Orders"),

                    menu(Icons.qr_code,
                        "Pass"),

                    menu(Icons.favorite_border,
                        "Favorites"),

                    menu(Icons.settings,
                        "Settings"),

                  ],

                ),


                const SizedBox(height:40),



                item(
                    "Inbox",
                    "View messages"
                ),


                item(
                    "Your Nike Member Benefits",
                    "2 available"
                ),


                item(
                    "Events",
                    "View All Events"
                ),



              ],

            ),

          );

        },

      ),

    );


  }





  Widget menu(
      IconData icon,
      String title
      ){

    return Column(

      children:[

        Icon(icon,size:35),

        const SizedBox(height:10),

        Text(title),

      ],

    );

  }



  Widget item(
      String title,
      String sub
      ){

    return ListTile(

      title:Text(
          title,
          style:
          const TextStyle(
              fontSize:22,
              fontWeight:
              FontWeight.bold
          )
      ),


      subtitle:
      Text(sub),


      trailing:
      const Icon(Icons.chevron_right),

    );

  }


}