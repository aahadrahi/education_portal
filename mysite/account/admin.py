from django.contrib import admin
from .models import IntroMadrasa,Course,Targets,Openions,Teachers,Gallery,SocialAccounts
# Register your models here.



class IntroMadrasaAdmin(admin.ModelAdmin):
    list_display=( 'logo','name', 'created_date')
    list_filter = ( 'created_date',)
    search_fields = ('name', )
    
class CourseAdmin(admin.ModelAdmin):
    list_display=( 'name','content', 'created_date')
    list_filter = ( 'created_date',)
    search_fields = ('name', )
    
class TargetsAdmin(admin.ModelAdmin):
    list_display=( 'name','content', 'created_date')
    list_filter = ( 'created_date',)
    search_fields = ('name', )
    
class OpenionsAdmin(admin.ModelAdmin):
    list_display=( 'profile_pic','name','email','title', 'created_date')
    list_filter = ( 'created_date',)
    search_fields = ('name', )
    
class TeachersAdmin(admin.ModelAdmin):
    list_display=( 'profile_pic','name','phone_no','position' ,'created_date')
    list_filter = ( 'created_date',)
    search_fields = ('name', )
    
class SocialAccountsAdmin(admin.ModelAdmin):
    list_display=( 'teacher','name',)
    list_filter = ( 'name',)
    search_fields = ('name', )
    
class GalleryAdmin(admin.ModelAdmin):
    list_display=( 'image','content', 'created_date')
    list_filter = ( 'created_date',)
    search_fields = ('name', )
    



admin.site.register(IntroMadrasa,IntroMadrasaAdmin)
admin.site.register(Course,CourseAdmin)
admin.site.register(Targets,TargetsAdmin)
admin.site.register(Openions,OpenionsAdmin)
admin.site.register(Teachers,TeachersAdmin)
admin.site.register(SocialAccounts,SocialAccountsAdmin)
admin.site.register(Gallery,GalleryAdmin)
