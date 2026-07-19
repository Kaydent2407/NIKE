import 'package:flutter/material.dart';

import 'all_shoes_screen.dart';


class ShopScreen extends StatelessWidget {

  final bool isNike;


  const ShopScreen({
    super.key,
    required this.isNike,
  });



  @override
  Widget build(BuildContext context) {


    final fgColor = isNike
        ? Colors.black
        : Colors.white;



    return ListView(

      padding: EdgeInsets.zero,

      children: [


        SizedBox(
          height: MediaQuery.of(context).padding.top + 70,
        ),



        Padding(

          padding:
          const EdgeInsets.symmetric(horizontal:20),

          child: Text(

            isNike
                ? 'Shop'
                : 'Shop Jordan',


            style: TextStyle(

              fontSize:34,

              fontWeight:
              FontWeight.bold,

              color:fgColor,

              letterSpacing:-0.5,

            ),

          ),

        ),



        const SizedBox(height:20),




        Padding(

          padding:
          const EdgeInsets.symmetric(horizontal:20),

          child: Row(

            children: [

              _buildTab(
                  isNike ? 'Men':'Streetwear',
                  true,
                  fgColor
              ),


              const SizedBox(width:24),


              _buildTab(
                  isNike ? 'Women':'Sport',
                  false,
                  fgColor
              ),



              const SizedBox(width:24),


              if(isNike)

                _buildTab(
                    'Kids',
                    false,
                    fgColor
                ),


            ],

          ),

        ),




        const SizedBox(height:20),




        _ExpandableBanner(

          title:'New & Featured',

          imageUrl:
          'https://images.unsplash.com/photo-1579952363873-27f3bade9f55',

          isNike:isNike,


          items:const [

            'Nike Football',

            'App Exclusive & Early Access',

            'New & Upcoming Drops',

            'National Team Kits',

            'New Releases',

            'Bestsellers',

            'LeBron James',

            'Member Shop',

            'Top Picks Under 3,000,000đ',

          ],

        ),





        _ExpandableBanner(

          title:'Shoes',

          imageUrl:
          'https://images.unsplash.com/photo-1605348532760-6753d2c43329',

          isNike:isNike,


          items:const [

            'All Shoes',

            'Lifestyle',

            'Running',

            'Basketball',

            'Football',

            'Training & Gym',

            'Skateboarding',

          ],



          onItemTap:(item){


            if(item=="All Shoes"){


              Navigator.push(

                context,


                MaterialPageRoute(

                  builder:(context)=>
                  const AllShoesScreen(),

                ),

              );


            }


          },


        ),






        _ExpandableBanner(

          title:'Clothing & Accessories',

          imageUrl:
          'https://images.unsplash.com/photo-1515886657613-9f3515b0c78f',

          isNike:isNike,


          items:const [

            'All Clothing',

            'Tops & T-Shirts',

            'Shorts',

            'Hoodies & Pullovers',

            'Trousers & Tights',

            'Jackets',

            'Socks',

          ],

        ),




        _ExpandableBanner(

          title:'Sale',

          imageUrl:
          'https://images.unsplash.com/photo-1542291026-7eec264c27ff',

          isNike:isNike,


          items:const [

            'Shop All Sale',

            'Shoes Sale',

            'Clothing Sale',

            'Accessories Sale',

          ],

        ),




        const SizedBox(height:30),




        _buildSectionHeader(
            'National Team Collections',
            fgColor
        ),



        const SizedBox(height:15),




        SizedBox(

          height:220,


          child:ListView(

            scrollDirection:
            Axis.horizontal,


            padding:
            const EdgeInsets.symmetric(horizontal:10),



            children:[


              _buildProductCard(

                imageUrl:
                'https://images.unsplash.com/photo-1584735174965-48c48d7028a9',

                title:
                'French Artistry',

                fgColor:fgColor,

              ),



              _buildProductCard(

                imageUrl:
                'https://images.unsplash.com/photo-1552346154-21d5981057c5',
                title:
                'Mercurial Scorpion',
                fgColor:fgColor,
              ),
            ],
          ),
        ),
        const SizedBox(height:120),
      ],
    );
  }


  Widget _buildTab(
      String text,
      bool active,
      Color fgColor
      ){


    return Column(
      crossAxisAlignment:
      CrossAxisAlignment.start,


      children:[
        Text(
          text,
          style:TextStyle(
            fontSize:16,
            fontWeight:
            active
                ? FontWeight.bold
                : FontWeight.w500,
            color:
            active
                ? fgColor
                : Colors.grey,
          ),
        ),



        const SizedBox(height:4),



        if(active)
          Container(
            height:2,
            width:30,
            color:fgColor,
          )
      ],
    );
  }

  Widget _buildSectionHeader(
      String title,
      Color color
      )
    {


    return Padding(
      padding:
      const EdgeInsets.symmetric(horizontal:20),

      child:Text(
        title,
        style:TextStyle(
          fontSize:20,
          fontWeight:
          FontWeight.w500,
          color:color,
        ),
      ),
    );
  }







  Widget _buildProductCard({
    required String imageUrl,
    required String title,
    required Color fgColor,
  }){


    return Padding(
      padding:
      const EdgeInsets.symmetric(horizontal:10),


      child:SizedBox(
        width:160,
        child:Column(
          crossAxisAlignment:
          CrossAxisAlignment.start,
          children:[
            Container(
              height:160,
              width:160,
              decoration:BoxDecoration(
                color:Colors.grey.shade300,
                image:DecorationImage(
                  image:
                  NetworkImage(imageUrl),
                  fit:BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height:10),



            Text(
              title,
              maxLines:2,
              style:TextStyle(
                color:fgColor,
                fontSize:14,
                fontWeight:
                FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}







class _ExpandableBanner extends StatefulWidget {
  final String title;
  final String imageUrl;
  final bool isNike;
  final List<String> items;
  final Function(String)? onItemTap;

  const _ExpandableBanner({
    required this.title,
    required this.imageUrl,
    required this.isNike,
    required this.items,
    this.onItemTap,
  }
);


  @override
  State<_ExpandableBanner> createState()=>_ExpandableBannerState();

}

class _ExpandableBannerState
    extends State<_ExpandableBanner>{
  bool expanded=false;



  @override
  Widget build(BuildContext context){
    final fgColor =
    widget.isNike
        ? Colors.black
        : Colors.white;
    final bgColor =
    widget.isNike
        ? Colors.white
        : Colors.black;
    final dividerColor =
    widget.isNike
        ? Colors.grey.shade300
        : Colors.grey.shade800;
    return Column(
      children:[
        GestureDetector(
          onTap:(){
            setState((){
              expanded=!expanded;
            });
          },



          child:Container(
            height:120,
            width:double.infinity,
            decoration:BoxDecoration(
              image:DecorationImage(
                image:
                NetworkImage(
                    widget.imageUrl
                ),
                fit:BoxFit.cover,
                colorFilter:
                ColorFilter.mode(
                  Colors.black.withValues(alpha:0.3),
                  BlendMode.darken,
                ),
              ),
            ),
            alignment:
            Alignment.centerLeft,
            padding:
            const EdgeInsets.only(left:20),
            child:Text(
              widget.title,
              style:const TextStyle(
                color:Colors.white,
                fontSize:22,
                fontWeight:
                FontWeight.w500,
              ),
            ),
          ),
        ),

        AnimatedSize(
          duration:
          const Duration(milliseconds:300),
          child:
          expanded?

          Container(
            color:bgColor,
            child:Column(
              children:
              widget.items.map((item){
                return InkWell(
                  onTap:(){
                    if(widget.onItemTap!=null){
                      widget.onItemTap!(item);
                    }
                  },
                  child:Container(
                    width:double.infinity,
                    padding:
                    const EdgeInsets.symmetric(
                      vertical:20,
                      horizontal:20,
                    ),


                    decoration:BoxDecoration(
                      border:Border(
                        bottom:
                        BorderSide(
                          color:dividerColor,
                        ),
                      ),
                    ),



                    child:Text(
                      item,
                      style:TextStyle(
                        color:fgColor,
                        fontSize:16,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          )
              :
          const SizedBox.shrink(),
        )
      ],
    );
  }
}