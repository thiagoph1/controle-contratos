from django.contrib.auth.signals import user_logged_in
from django.db.models.signals import post_delete, post_save
from django.dispatch import receiver

from .middleware import get_current_user
from .models import AuditLog, TimeStampedModel


@receiver(post_save)
def audit_save(sender, instance, created, raw=False, **kwargs):
    if raw or sender is AuditLog or not isinstance(instance, TimeStampedModel):
        return
    actor = get_current_user()
    AuditLog.objects.create(
        actor=actor if getattr(actor, 'is_authenticated', False) else None,
        action=AuditLog.Action.CREATE if created else AuditLog.Action.UPDATE,
        model_name=str(instance._meta.verbose_name),
        object_id=str(instance.pk),
        representation=str(instance)[:255],
    )


@receiver(post_delete)
def audit_delete(sender, instance, **kwargs):
    if sender is AuditLog or not isinstance(instance, TimeStampedModel):
        return
    actor = get_current_user()
    AuditLog.objects.create(
        actor=actor if getattr(actor, 'is_authenticated', False) else None,
        action=AuditLog.Action.DELETE,
        model_name=str(instance._meta.verbose_name),
        object_id=str(instance.pk),
        representation=str(instance)[:255],
    )


@receiver(user_logged_in)
def audit_login(sender, request, user, **kwargs):
    AuditLog.objects.create(
        actor=user,
        action=AuditLog.Action.LOGIN,
        model_name='Sistema',
        object_id=str(user.pk),
        representation=f'Acesso de {user.get_full_name() or user.username}',
        changes={'ip': request.META.get('REMOTE_ADDR', '')},
    )
